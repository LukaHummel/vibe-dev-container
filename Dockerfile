FROM mcr.microsoft.com/devcontainers/universal:6-linux

# Install system dependencies and coding agent tools
RUN apt-get update \
    && apt-get -y install \
        git \
        curl \
        wget \
        build-essential \
        python3 \
        python3-dev \
        python3-pip \
        pkg-config \
        libssl-dev \
        unzip \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh) for interacting with GitHub repositories
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

#Install fnm (Fast Node Manager) for managing Node.js versions
RUN curl -fsSL https://fnm.vercel.app/install | bash

# Install Node.js latest LTS (required for Codex CLI and T3 Code)
# The universal image already includes Node.js, but ensure it's up to date
RUN npm install -g npm@latest

# Install Codex CLI
RUN npm install -g @openai/codex

# Install OpenCode (open-source AI coding agent)
RUN curl -fsSL https://opencode.ai/install | bash

# Install T3 Code (agent harness control surface)
RUN npm install -g t3@latest

# Set up environment for coding agents
ENV PATH="/root/.local/bin:$PATH"