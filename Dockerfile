FROM mcr.microsoft.com/devcontainers/universal:6-linux

# Install system dependencies and coding agent tools
RUN apt-get update \
    && apt-get -y install \
        git \
        curl \
        wget \
        build-essential \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js latest LTS (required for Codex CLI and T3 Code)
# The universal image already includes Node.js, but ensure it's up to date
RUN npm install -g npm@latest

# Install Codex CLI
RUN npm install -g @openai/codex

# Install OpenCode (open-source AI coding agent)
RUN curl -fsSL https://opencode.ai/install | bash

# Install T3 Code (agent harness control surface)
RUN npx t3 serve --host "$(tailscale ip -4)"

# Set up environment for coding agents
ENV PATH="/root/.local/bin:$PATH"