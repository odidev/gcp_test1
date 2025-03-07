FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["gke-demo.csproj", "./"]
RUN dotnet restore "./gke-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "gke-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "gke-demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "gke-demo.dll"]
