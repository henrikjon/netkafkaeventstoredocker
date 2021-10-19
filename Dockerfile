FROM mcr.microsoft.com/dotnet/sdk:6.0.100-rc.2 AS build

WORKDIR /source

# Copy and restore
COPY *.csproj ./
RUN dotnet restore

# Build and publish project
COPY ./* ./
RUN dotnet publish -c release -o /app --no-restore

# Create final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim
WORKDIR /app
COPY --from=build /app .
ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "Events.dll"]