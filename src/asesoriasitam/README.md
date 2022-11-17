# Código Front-End

El código fuente del front-end de la aplicación.


Escrito en [Flutter 3.3.6](https://flutter.dev/), que a su vez está basado en [Dart](https://dart.dev/).

Contiene integración con el back-end de google [Firebase](https://firebase.google.com/). 


La organización del código es la siguiente:

```

lib: la carpeta con el código (todo lo demás es autogenerado)

    db: todo lo que tiene que ver con conectarse al backend (Firebase)

        clases: se definen clases y variables que contienen sin lógica

        [clase]_bloc.dart: define la lógica que acompaña a una clase

    pantallas: implementación de todas las pantallas

    utils: funciones de utilidad

    widgets: implementación atómica de widgets personalizados

    firebase_options.dart (Configuración del back-end - NO CAMBIAR)

    global.dart (Clase con variables globales)

    pallete.dart (Clase con colores, etc. que define la temática)

    themes.dart (Archivo con declaración de temáticas)
    
    main.dart (Punto de entrada de la aplicación - NO CAMBIAR) 


```

## Cómo deployar

Desde /ser/asesoriasitam:
```
firebase init
```

y seleccionar Hosting y 'build/web' como folder


```
flutter build web
```

```
firebase deploy
```

