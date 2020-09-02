const RPC = require("discord-rpc");
const fs = require("fs");
const path = require("path");

const configPath = path.resolve(__dirname, "./config.json");
const { assets, clientId } = readConfig();
const extensions = Object.keys(assets);

const client = new RPC.Client({ transport: "ipc" });
let currentBuffer;

function readConfig() {
  return JSON.parse(fs.readFileSync(configPath), "utf8");
}

function updateActivity(client) {
  const { ignored, buffer, details, state, largeImageText } = readConfig();

  if (buffer == currentBuffer) return;
  currentBuffer = buffer;

  const i = ignored.some(x => {
    const r = new RegExp(x);
    return r.test(buffer);
  });

  if (i) return;

  const e = extensions.find(x => {
    const r = new RegExp(x);
    return r.test(buffer);
  });

  const largeImageKey = assets[e] || assets["_default"];
  const startTimestamp = new Date();
  client.setActivity({ details, state, startTimestamp, largeImageKey, largeImageText });
}

client.once("ready", _ => {
  updateActivity(client);
  setInterval(_ => updateActivity(client), 15000);
});

client.login({ clientId });
