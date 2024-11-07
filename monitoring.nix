{ config, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.ketamin.trade";
        http_port = 3001;
        http_addr = "::1";
      };
      "auth.anonymous" = {
        enabled = true;
        org_name = "Main Org.";
        org_role = "Viewer";
      };
    };
  };
  services.prometheus = {
    scrapeConfigs = [
      {
        job_name = "nodes";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [
              "10.10.1.25:9100"
              "10.10.1.22:17871"
              "shit.ketamin.trade:9100"
              "localhost:9100"
              "localhost:9753"
              "localhost:9633"
              "localhost:9708"
              "localhost:56231"
              "localhost:51711"
              "localhost:51235"
              "localhost:51211"
              "localhost:51231"
            ];

          }
        ];
      }
      {
        job_name = "unifi";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [ "localhost:9130" ];

          }
        ];
      }
    ];
    enable = true;
    port = 1312;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
      restic = {
        refreshInterval = 1800;
        user = "prometheus";
        enable = true;
        repository = "rclone:smb:/Buro/backup";
        passwordFile = "/var/lib/secrets/restic";
        rcloneConfigFile = "/srv/pass";
      };
      smartctl = {
        enable = true;
        devices = [
          "/dev/sda"
          "/dev/sdb"
        ];
      };
      exportarr-prowlarr = {
        enable = true;
        port = 51231;
        apiKeyFile = "/var/lib/secrets/prowlarr";
        user = "prometheus";
        url = config.services.nginx.virtualHosts."prowlarr.ketamin.trade".locations."/".proxyPass;
      };
      exportarr-lidarr = {
        enable = true;
        port = 56231;
        apiKeyFile = "/var/lib/secrets/lidarr";
        user = "prometheus";
        url = config.services.nginx.virtualHosts."lidarr.ketamin.trade".locations."/".proxyPass;
      };
      exportarr-sonarr = {
        enable = true;
        port = 51211;
        apiKeyFile = "/var/lib/secrets/sonarr";
        user = "prometheus";
        url = config.services.nginx.virtualHosts."sonarr.ketamin.trade".locations."/".proxyPass;
      };
      exportarr-radarr = {
        enable = true;
        port = 51711;
        user = "prometheus";
        url = config.services.nginx.virtualHosts."radarr.ketamin.trade".locations."/".proxyPass;
        apiKeyFile = "/var/lib/secrets/radarr";
      };
      exportarr-bazarr = {
        enable = true;
        port = 51235;
        user = "prometheus";
        url = config.services.nginx.virtualHosts."bazarr.ketamin.trade".locations."/".proxyPass;
        apiKeyFile = "/var/lib/secrets/bazarr";
      };
    };
  };
}
