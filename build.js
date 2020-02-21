const AdmZip = require('adm-zip');
const fs = require('fs');
const path = require('path');
const minimatch = require("minimatch")
const pjson = require('./package.json');

const scriptName = path.basename(__filename);
let preview = false;

const args = process.argv.slice(2);
args.forEach(val => {
  if(val == '--preview') {
    preview = true;
  }
});

// Config
const out_dir = __dirname + '/dist';
const name = 'anvil_of_destiny';
const version = pjson.version;
const root_folder = __dirname;
const ignore_list = [
  'node_modules',
  'dist',
  'files/debug',
  'gimp',
  '.*',
  '*.zip',
  'anvil_preview.gif',
  'idea.lua',
  'LICENSE',
  'README.md',
  'TODO.md',
  '**/boop1.txt',
  'package*.json',
  'rune_alphabet.png',
  'rune_alphabet_sprites.png',
  'rune_alphabet_typer.htm',
  'rune_texts.txt',
  'Modworkshop Readme.txt',
  'fmod',
  'workshop.xml',
  'workshop_id.txt',
  'workshop_preview_image.png',
  'mod_id.txt',
];
// Config end

ignore_list.push(scriptName);

function is_dir(path) {
  try {
      var stat = fs.lstatSync(path);
      return stat.isDirectory();
  } catch (e) {
      // lstatSync throws an error if path doesn't exist
      return false;
  }
}

const addFiles = item => {
  if(ignore_list.every(ignore_entry => !minimatch(item, ignore_entry))) {
    if(is_dir(__dirname + '/' + item)) {
      fs.readdirSync(__dirname + '/' + item).forEach(entry => {
        const child_item = `${item}/${entry}`;
        addFiles(child_item);
      });
    } else {
      const folderName = item.substr(0, item.lastIndexOf('/'));
      if(preview) {
        console.log(item);
      } else {
        zip.addLocalFile(`${__dirname}/${item}`, `${name}/${folderName}`);
      }
    }
  }
};

const zip = new AdmZip();

fs.readdirSync(root_folder).forEach(entry => {
  addFiles(entry);
});

if(!preview) {
  if (!fs.existsSync(out_dir)) {
    fs.mkdirSync(out_dir);
  }
  zip.writeZip(`${out_dir}/${name}_v${version}.zip`);
}
