# Pokedex
## _Todos tus Pokemones Disponibles!_

## Características

- Lista de Pokemones
- Busqueda y filtros por nombre, id o tipo de pokemones
- Agregar a favoritos
- Ver lista de Evoluciones
- Poder compartir tus pokemones con tus amigos

## Tecnologias

Pokedex utiliza varias tecnologias para funcionar:

- [Shared Preferences] - Para Almacenar Informacion en el dispositivo
- [Flutter] - Framework Base
- [Share_Plus] - Para Compartir tus pokemones fuera de la App

## Metodologias

Para esta App, debido a la estructura del API a consumir, tuvimos que priorizar el performance encima de todo, por lo que tuvimos que minimizar los fetchs que se aplicaban al endpoint y por tal razon lo ejecutamos en momentos muy precisos y trayendo solo la data necesaria, sin sobrecargar el consumo de data.



