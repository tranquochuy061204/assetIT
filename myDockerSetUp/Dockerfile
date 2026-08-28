# escape=`

# ==========================================
# Windows Server 2019 (build 17763) - Node.js 22 LTS
# ==========================================

# Stage 1: Build Frontend (Client)
# Node.js v24.19.0 LTS
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS client-builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Tải Node.js 24 LTS
RUN Invoke-WebRequest -Uri 'https://nodejs.org/dist/v24.19.0/node-v24.19.0-win-x64.zip' `
    -OutFile 'C:\node.zip' -UseBasicParsing
RUN Expand-Archive -Path 'C:\node.zip' -DestinationPath 'C:\'
RUN Rename-Item 'C:\node-v24.19.0-win-x64' 'C:\nodejs'
RUN Remove-Item 'C:\node.zip' -Force

RUN $env:PATH = 'C:\nodejs;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, 'Machine')

WORKDIR C:/build/client

COPY client/package*.json ./
SHELL ["cmd", "/S", "/C"]
RUN C:\nodejs\npm.cmd install

COPY client/ ./
ENV VITE_API_URL=/api
RUN C:\nodejs\npm.cmd run build

# Stage 2: Server & Production Runner
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS runner

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Tải Node.js 24 LTS
RUN Invoke-WebRequest -Uri 'https://nodejs.org/dist/v24.19.0/node-v24.19.0-win-x64.zip' `
    -OutFile 'C:\node.zip' -UseBasicParsing
RUN Expand-Archive -Path 'C:\node.zip' -DestinationPath 'C:\'
RUN Rename-Item 'C:\node-v24.19.0-win-x64' 'C:\nodejs'
RUN Remove-Item 'C:\node.zip' -Force

RUN $env:PATH = 'C:\nodejs;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, 'Machine')

WORKDIR C:/app

COPY server/package*.json ./server/
WORKDIR C:/app/server
SHELL ["cmd", "/S", "/C"]
RUN C:\nodejs\npm.cmd install --only=production

COPY server/ ./

COPY --from=client-builder C:/build/client/dist C:/app/client/dist

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
RUN New-Item -Path 'C:\app\server\inputs' -ItemType Directory -Force; `
    New-Item -Path 'C:\app\server\processed' -ItemType Directory -Force

ENV NODE_ENV=production
ENV PORT=3001
ENV HOST=0.0.0.0

EXPOSE 3001

CMD ["powershell", "-Command", "Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses ('10.1.1.26','8.8.8.8','1.1.1.1') -ErrorAction SilentlyContinue; C:\\nodejs\\node.exe src/server.js"]
