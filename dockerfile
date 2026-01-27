# Use a specific version for immutability
FROM hashicorp/terraform:1.7.0

# 1. Set up the Plugin Cache directory
ENV TF_PLUGIN_CACHE_DIR="/opt/terraform/plugin-cache"
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}

# 2. Pre-cache specific providers
# We create a dummy file just to trigger the download of providers
WORKDIR /tmp/cache_build
COPY <<EOF providers.tf
terraform {
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.0" }
    helm       = { source = "hashicorp/helm", version = "~> 2.0" }
  }
}
EOF

# Run init to download providers into the cache
# -backend=false ensures we don't need AWS creds during the build
RUN terraform init -backend=false && \
    rm -rf .terraform providers.tf

# 3. Final Image Setup
WORKDIR /app
# This ensures that any 'terraform init' run later will check the cache first
COPY <<EOF /root/.terraformrc
plugin_cache_dir = "$TF_PLUGIN_CACHE_DIR"
disable_checkpoint = true
EOF

# Standard Entrypoint (from the previous step)
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]