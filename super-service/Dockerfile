# Step 1: Build stage
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
WORKDIR /app

COPY ./src/ ./src/
COPY ./test/ ./test/

RUN dotnet restore ./src/SuperService.csproj
RUN dotnet restore ./test/SuperService.UnitTests.csproj

# Run unit tests
RUN dotnet test ./test/SuperService.UnitTests.csproj --no-restore --verbosity normal

# Publish the main application only if tests pass
RUN dotnet publish ./src/SuperService.csproj -c Release -o /out

# Step 2: Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build-env /out .

EXPOSE 80
ENTRYPOINT ["dotnet", "SuperService.dll"]
