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
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install node

# Load nvm in non-interactive shells
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

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