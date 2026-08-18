FROM mcr.microsoft.com/devcontainers/universal:6-linux

# Switch to root for system package installation
USER root

RUN apt-get update && apt-get -y install \
        git curl wget build-essential python3 python3-dev python3-pip \
        pkg-config libssl-dev unzip \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && wget -nv -O- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install gh -y

# Switch to the non-root user provided by the base image
USER codespace

# Install user-level tools
RUN curl -fsSL https://fnm.vercel.app/install | bash \
    && curl -fsSL https://opencode.ai/install | bash \
    && npm install -g npm@latest @openai/codex t3@latest

ENV PATH="/home/codespace/.local/bin:$PATH"

# Copy and set entrypoint script
USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER codespace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]