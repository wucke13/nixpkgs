use serde::Deserialize;
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use bootspec::BootJson;

#[derive(Deserialize)]
pub struct Config {
    pub firmware: String,
    pub modprobe_binary: String,
    pub nix_store_mount_opts: Vec<String>,
    pub env_binary: Option<String>,
    pub sh_binary: Option<String>,
    pub etc_basedir: Option<String>,
    pub etc_metadata_image: Option<String>,
}

impl Config {
    /// Read the config from the metadata file in the toplevel directory.
    pub fn from_toplevel(toplevel: impl AsRef<Path>, prefix: &str) -> Result<Self> {
        let bootspec_path =
            PathBuf::from(prefix).join(toplevel.as_ref().join("boot.json").strip_prefix("/")?);

        let boot_json: BootJson = fs::read(bootspec_path)
            .context("Failed to read bootspec file")
            .and_then(|raw| {
                let mut bootspec: serde_json::Value =
                    serde_json::from_slice(&raw).context("Failed to parse bootspec JSON")?;
                if let Ok(serde_json::Value::Object(map)) = bootspec
                    .get_mut("org.nixos.bootspec.v1")
                    .context("Bootspec does not contain NixOS bootspec key")
                {
                    map.entry("kernel").or_insert("/dev/null".into());
                    map.entry("kernel_params").or_insert(from_value([])?);
                } else {
                    anyhow::bail!("Bootspec does not contain nixos bootspec key")
                }
                eprintln!("{bootspec:#?}");
                serde_json::from_value(bootspec).context("Failed to read bootspec JSON")
            })?;

        let config = boot_json
            .extensions
            .get("org.nixos.nixos-init.v1")
            .context("Failed to extract nixos-init bootspec extension")
            .and_then(|v| {
                serde_json::from_value(v.clone()).context("Failed to deserialise config")
            })?;

        Ok(config)
    }
}
