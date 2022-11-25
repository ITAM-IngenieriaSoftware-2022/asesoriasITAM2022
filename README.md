# Proyecto Final de Ing. de Software | Equipo Bueno

Proyecto final del equipo "BUENO" para la materia de Ing. de Software Otoño 2022.

[URL con el proyecto funcionando](https://asesoriasitam.web.app/)

## Requirements

[Aquí el SRS](https://github.com/emiliocantuc/proyectoFinalSoftware/blob/main/SRS.md)

## Casos de uso

[Caso de uso : Login](https://github.com/emiliocantuc/proyectoFinalSoftware/blob/main/Casos%20de%20uso%20Login.png)

[Caso de uso : Buscar Asesoría](https://github.com/emiliocantuc/proyectoFinalSoftware/blob/main/Casos%20de%20uso-Buscar%20Asesor%C3%ADa.png)

[Caso de uso : Comentar Asesoría](https://github.com/emiliocantuc/proyectoFinalSoftware/blob/main/Casos%20de%20uso-Comentar%20Asesor%C3%ADa.png)

## Plan de Calidad

En esta sección explicaremos ciertas características del producto que creemos que seran importantes tanto para los usuarios como para los desarrolladores para mantener la calidad.
Queremos crear productos que sean exitosos, confiables y que duren la mayor cantidad de tiempo, es decir, se mantengan vigentes y útiles.

Uno de los pilares seguidos para el desarrollo de Asesorías ITAM fue priorizar la integridad y corrección de la plataforma y sus servicios antes que su flexibilidad y adaptabilidad. Consideramos que esta preferencia garantiza mayor robustez, y por ende, responde a nuestro objetivo de garantizar confiabilidad.

Ante este primer pilar contraponemos, sin embargo, una dedicación por la interoperabilidad y la portabilidad. Queremos garantizar que Asesorías ITAM este disponible libre de errores en las siguientes plataformas: Windows, Linux, MacOS, Android, iOS y Web.

## Arquitectura y justificación

La arquitectura que usamos es la de microservicios, ya que es la mejor adaptada al momento de desarrollar una aplicación web como esta. Por otro lado, decidimos esta arquitectura, ya que justo se pueden hacer distintos microservicios en nuestra app, por ejemplo: el momento de crear una asesoría, buscar asesorías, comprar asesorías entre otros servicios dados, además de que nuestro backend maneja una base de datos, la cual almacena toda la información necesaria para el uso de la página.

## Metodología y justificación

La metodología de desarrollo de software que decidimos usar para este proyecto fue SCRUM, la cual deriva de la metodología AGILE.
Expondremos algunas de las razones por las que consideramos que esta metodologia sería la más idonea.

Primero que nada, por la familiaridad. Debemos admitir que esta metodología ya la habíamos utilizado anteriormente en otra materia para desarrollar una aplicación.

La segunda razón más importante fue la configuración del tiempo que disponíamos para desarrollar. Inicialmente, supimos que podríamos disponer de una reunión de duración moderada en la que pudimos acordar cuales features tendríamos que desarrollar y, sobre todo, que prioridad tomaría cada una. Esto se acomoda perfectamente en el marco de trabajo de un Backlog. Este backlog fue acordado por los miembros del equipo, y luego, se asignaron responsabilidades. Quedó acordado que Emilio sería el Scrum Master.

Las reuniones SCRUM en las que nos notificabamos del progreso y obstáculos que íbamos enfrentando se acomodaron con naturalidad en los días viernes en los que teníamos clase. Ya sea durante los breaks, las conversaciones casuales o al final de la clase de Ingeniería de Software.

Una tercera razón que terminó por aclarar la elección de metodología es que conocemos que SCRUM es adecuado para proyectos pequeños y de corta duración. También es más adecuado cuando todos los miembros del equipo tienen experiencia tanto en desarrollo colaborativo como en el cumplimiento de la metodología.

## Documentación para replicar

Para contribuir al codigo seguir los siguientes pasos:

1. Sigue la [documentación para descargar](https://docs.flutter.dev/get-started/install) Flutter, el framework utilizado en el proyecto.

2. Clonar el repositorio: `git clone https://github.com/emiliocantuc/proyectoFinalSoftware.git`.

3. Abrir el repositorio en entorno de desarrollo recomendado [VS Code](https://code.visualstudio.com/) y descargar el [plugin de Flutter](https://docs.flutter.dev/development/tools/vs-code).

4. Crea una nueva rama del repositorio siguiendo [estos pasos](https://dumbitdude.com/how-to-create-a-new-branch-using-visual-studio-code/).

5. Agrega tus cambios al código.

6. Sigue [estos pasos](https://docs.flutter.dev/development/tools/vs-code) para correr el código localmente. NOTA: Usa Chrome como dispositivo. 

7. Haz commit de tus cambios y publica tu rama. Checa [este tutorial](https://code.visualstudio.com/docs/sourcecontrol/overview) para usar Git en VS Code. 

8. En GitHub.com, realiza un pull request de tu rama explicando tus cambios. Si tus cambios son aceptados por el equipo serán agregados a la rama principal. 

**NOTA**: La organización del código está descrita en el README en `src/asesoriasitam/`.

## Propuesta económica
Para **Asesorías ITAM ®** presentamos el siguiente modelo de negocios:
1. Al ser un modelo de asesorías, buscamos crear una base de asesores y asesorados manteniendo una alta retención de ambos, por lo que ofreceríamos una suscripción para cada tipo de usuario:
    - Asesor: Un cobro por comisión de su asesoría o bien un plan mensual de alrededor de 250 MXN. Ambas con acceso a la funcionalidades actuales y permitiendo seguir desarrollando y expandiendo para tener un sistema de videoconferencias, pizarron en linea, base de datos de información, etc...
    - Asesorado: Un plan mensual de alrededor de 350MXN que le permitiría un número de asesorías a la semana, así como acceso a distintas funcionalidades exclusivas y orientadas a su aprendizaje.
 2. Al definirnos como una empresa de servicios escolares, buscamos que ser parte de las universidades y contribuir a satisfacer sus necesidades por lo que ofrecemos un modelo de contrato para implementar las asesorías de forma local, así como poner a disposición los recursos de la plataforma para profesores. Parte de esta renta tambien es desarrollar funcionalidad personalida para la institucipn que a través de un grupo de expertos en educación y docentes de la universidad.

## Presentación
[Link a Google Docs de la presentación. Presiona y sorprendase Ms. Paulina](https://docs.google.com/presentation/d/1Bu9jBGTcVGaqiuu9Snw94E8GHmIwlY1hy_BEB5NB3A4/edit#slide=id.p)

