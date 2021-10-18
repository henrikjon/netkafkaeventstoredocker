FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim AS build

WORKDIR /source

# copy and restore
COPY *.csproj ./aspnetapp/
RUN dotnet restore

# build and publish project
COPY aspnetapp/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore


# final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim
WORKDIR /app
COPY --from=build /app .
ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "Events.dll"]
