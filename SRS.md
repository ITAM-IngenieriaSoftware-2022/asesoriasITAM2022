# Software Requirements Specifications (SRS)

Autores:
- Emilio Cantú Cervini
- Elmer Adrián Ortega Váldes
- Josue Doménico Chicatti Avendaño
- Juan Pablo Macías Watson
- Pedro Olivares Sánchez



## Índice
  1. [Introducción](#introduccion)
  2. [Descripción general](#descripcion-general)
  3. [Requerimientos de la interfaz externa](#requerimientos1)
  4. [Funcionalidades del sistema](#requerimientos2)
  5. [Requerimientos no funcionales](#requerimientos-no-funcionales)

## 1. Introducción <a name="introduccion"></a>
  ### 1.1 Propósito
  
  Este documento busca detallar y describir el programa de Asesorías ITAM. Exploraremos tanto los requerimientos y funcionalidades del sistema como los requerimientos no funcionales, más los requerimientos de la interfaz externa.

  ### 1.2 Convenciones del documento
  
  Se adoptó el estándar IEEE para SRS para redactar este documento.
  
  ### 1.3 Audiencia esperada y sugerencias de lectura
  
  La audiencia de este documento son los futuros desarrolladores que le darán mantenimiento y actualizaciones al programa de Asesorías ITAM. Como sugerencia de lectura proponemos la documentación de Flutter y Dart.
  
  ### 1.4 Alcance del producto
  
  El programa Asesorías ITAM, desarrollado por el equipo BUENO, busca proveer a los alumnos del ITAM con una herramienta útil, fácil de usar e integradora para la comunidad, al proveer la capacidad de publicar, buscar y calificar asesorías de materías específicas por y para estudiantes, para evitar los inconvenientes que hoy día sufren los miembros de la comunidad al no tener una manera accesible de encontrar asesorías.
  
  ### 1.5 Referencias

  https://github.com/emiliocantuc/proyectoFinalSoftware/

## 2. Descripción general <a name="descripcion-general"></a>

  ### 2.1 Perspectiva del producto
  
  Este producto de software se originó al identificar la falta de medios accesibles de solicitar y publicar asesorías. Actualmente, los estudiantes del ITAM que buscan y promocionan asesorías lo hacen por medio del grupo del Facebook o por medio de las pizarras físicas del ITAM. 

  El sistema busca, mediante una página web, proveer un mecanismo para que los estudiantes puedan publicar asesorías de la matería que gusten, junto con detalles como precio, lugar y horario. A su vez, buscamos que los estudiantes usuarios en busca de asesorías puedan encontrarlas por matería, así como tener un feed en donde se desplieguen las asesorías más populares que, al hacerles clic, se puedan visualizar los detalles antes mecionados así como comentarios realizados por otros estudiantes.

  ### 2.2 Funciones del producto
  

  - Crear cuenta usando un correo electrónico personal.
  - Ingresar a la página principal mediante login.
  - Tener la capacidad de ingresar a "mi perfil" en todo momento.
  - Tener la capacidad de cerrar sesión en todo momento.
  - Tener la capacidad de anunciar asesorías en todo momento.
  - Tener un feed en donde se despliegue la lista de materias para buscar, así como las asesorías más populares.
  - Poder ingresar a cada asesoría publicada, ya sea en el feed o mediante búsqueda por materia, para ver detalles y poder agregar comentarios.


  ### 2.3 Clases de usuario y características
  
  Estudiantes del ITAM que busquen anunciar sus servicios de asesorías para ciertas materias (y posiblemente ganar dinero). Estudiantes del ITAM que estén en busca de asesorías.
  
  ### 2.4 Ambiente de operación

  El programa opera en la web, para los navegadores Chrome, Firefox y Edge. Tiene versión de escritorio y móvil.

  ### 2.5 Restricciones de diseño e implementación
  
  La restricción más importante fue el tiempo limitado que tuvimos para desarrollar este proyecto.
  
  ### 2.6 Documentación de usuario

  Los READMEs de cada componente del proyecto se encuentran en: https://github.com/emiliocantuc/proyectoFinalSoftware/
  
  ### 2.7 Suposiciones y dependencias
  
  Se asume y depende de que el usuario provea una cuenta de correo personal, así como de los frameworks Firebase 6.11.5 y Flutter 3.6.0 de Google, y de los navegadores Chrome 107.0.5304.107, Firefox 107.0 y Edge 106.0. El sitio se hostea mediante Firebase hosting.

## 3. Requerimientos de interfaz externa <a name="requerimientos1"></a>

  ### 3.1 Interfaces de Usuario
  
  Existen dos pantallas principales en la aplicación, la primera es el feed que da la opción de buscar por materias junto con las asesorías más recomendadas, la segunda es la pantalla que tiene el formulario a llenar para poder dar de alta una asesoría.

  ### 3.2 Interfaces de hardware
  
  Cualquier dispositivo que soporte abrir un navegador y tenga conectividad a internet soporta nuestro programa.
  
  ### 3.3 Interfaces de software
  
  Asesorías ITAM hace uso del framework flutter y firebase para manejar bases de datos no-relacionales.

## 4. Funcionalidades del sistema <a name="requerimientos2"></a>

  ### 4.1 Crear cuenta

   #### 4.1.1 Descripción y prioridad

   Prioridad alta. El usuario da un email propio para crear una cuenta en el sistema. 

   #### 4.1.2 Estímulos y sucesión de respuestas

  Los usuarios se enteran de nuestra aplicación y quieren crear una cuenta para usar nuestro sistema. 
  
  #### 4.1.3 Requerimientos funcionales

  - REQ-1: El usuario que busca registrarse puede llenar un formulario con su email y contraseña para crear su cuenta.
  - REQ-2: Una vez subido el formulario, se manda un mail para autenticar al usuario y crear su cuenta.

  ### 4.2 Login

   #### 4.1.1 Descripción y prioridad

   Prioridad alta. El usuario da su cuenta para ingresar al sistema. 

   #### 4.1.2 Estímulos y sucesión de respuestas

  Los usuarios se enteran de nuestra aplicación o buscan asesorías y quieren usar nuestro sistema. 
  
   #### 4.1.3 Requerimientos funcionales

  - REQ-1: El usuario puede ingresar sus datos para ingresar al sistema.

  ### 4.3 Crear asesoría

  #### 4.1.1 Descripción y prioridad

   Prioridad alta. El usuario ingresa al sistema y se le despliega un formulario que le permite crear una asesoría con todos sus detalles. 

   #### 4.1.2 Estímulos y sucesión de respuestas

  Un usuario en capacidad de ofrecer asesorías busca publicar una usando nuestro sistema.
  
   #### 4.1.3 Requerimientos funcionales

  - REQ-1: El usuario puede hacer clic en un botón que lo lleva a la pantalla para crear asesorías.
  - REQ-2: Al usuario se le despliega un formulario que le pide dar detalles sobre: la materia, el precio de la asesoría, el horario y los lugares.
  - REQ-3: Al usuario se le presenta un mensaje de confirmación después de publicar su asesoría.

  ### 4.4 Buscar asesoría

  #### 4.1.1 Descripción y prioridad

   Prioridad alta. El usuario puede buscar asesorías mediante una búsqueda por materias.

   #### 4.1.2 Estímulos y sucesión de respuestas

  Un usuario en busca de asesorías usa nuestro sistema para encontrarlas.
  
   #### 4.1.3 Requerimientos funcionales

  - REQ-1: El usuario puede hacer clic un botón con el nombre de la materia en la cual quiere buscar una asesoría.

  ### 4.5 Comentar asesoría

  #### 4.1.1 Descripción y prioridad

   Prioridad alta. El usuario puede comentar las asesorías, aunque no las haya tomado.

   #### 4.1.2 Estímulos y sucesión de respuestas

  Un usuario ve un asesoría interesante o que ya tomo y quiere comentar su experiencia.
  
   #### 4.1.3 Requerimientos funcionales

  - REQ-1: El usuario puede hacer clic en una asesoría y tiene un text box en donde pude escribir un comentario.

  - REQ-2: Al usuario se le pregunta si recomienda o no a su asesor.

## 5. Requerimientos no funcionales <a name="requerimientos-no-funcionales"></a>

  ### 5.1 Requerimientos de seguridad
  
  Firebase de Google maneja toda la parte de seguridad y auteticación relacionado a las cuentas. A su vez, Flutter maneja sesiones con cookies.
  

