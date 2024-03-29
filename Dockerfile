#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Pet.Project.Pet.Finder.Api/Pet.Project.Pet.Finder.Api.csproj", "Pet.Project.Pet.Finder.Api/"]
COPY ["Pet.Project.Pet.Finder.Domain/Pet.Project.Pet.Finder.Domain.csproj", "Pet.Project.Pet.Finder.Domain/"]
COPY ["Pet.Project.Pet.Finder.Infraestructure/Pet.Project.Pet.Finder.Infraestructure.csproj", "Pet.Project.Pet.Finder.Infraestructure/"]
RUN dotnet restore "Pet.Project.Pet.Finder.Api/Pet.Project.Pet.Finder.Api.csproj"
COPY . .
WORKDIR "/src/Pet.Project.Pet.Finder.Api"
RUN dotnet build "Pet.Project.Pet.Finder.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pet.Project.Pet.Finder.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pet.Project.Pet.Finder.Api.dll"]