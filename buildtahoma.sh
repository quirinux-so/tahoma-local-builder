#!/bin/bash
set -e

# ======================================================================
# File:       buildtahoma.sh :: Tahoma Script Build for Ubuntu 20.04
# Author:     Charlie Martínez® <cmartinez@quirinux.org>
# License:    BSD 3-Clause "New" or "Revised" License
# Purpose:    Metascript that collects the original Tahoma2D build CI scripts.
# Supported:  Only works in Ubuntu 20.04
# =====================================================================
# This code gathers all the official Tahoma2D build CI scripts into a 
# single one, tailored for a specific environment.
#
# Made for the development of Quirinux Tweaks, this script uses 
# Charlie Martínez’s GitHub repositories instead of the official Tahoma2D 
# repositories for building the software. While some improvements from 
# Quirinux Tweaks may be incorporated into the official development, 
# this repository is not an official Tahoma2D project.

# =====================================================================
# Co-Authored-By: manongjohn <19245851+manongjohn@users.noreply.github.com>
# Co-Authored-By: jeremybullock <79284068+jeremybullock@users.noreply.github.com>
# =====================================================================

#
# Copyright (c) 2019-2025 Charlie Martínez. All Rights Reserved.  
# License: BSD 3-Clause "New" or "Revised" License
# Authorized and unauthorized uses of the Quirinux trademark:  
# See https://www.quirinux.org/aviso-legal  
#
# Tahoma2D and OpenToonz are registered trademarks of their respective 
# owners, and any other third-party projects that may be mentioned or 
# affected by this code belong to their respective owners and follow 
# their respective licenses.
#

_000_var () {

	REPO_URL="https://github.com/charliemartinez/tahoma2d.git" #author script fork
	OPTS=""
	SCRIPT_DIR="$(dirname "$(realpath "$0")")"

		# Verify if the script is inside the ci-scripts/linux/local-build directory.
		if [[ "$SCRIPT_DIR" == */ci-scripts/linux/local-build ]]; then
			TAHOMA_DIR="$(realpath "$SCRIPT_DIR/../../..")"
		else
			TAHOMA_DIR="$SCRIPT_DIR/tahoma2d"
		fi

	USER_CONFIG_DIR="$HOME/.config/Tahoma2D"
	STUFF_DIR="$TAHOMA_DIR/stuff"
	THIRDPARTY_DIR="$TAHOMA_DIR/thirdparty"
	LIBTIFF_DIR="$THIRDPARTY_DIR/tiff-4.2.0"
	TOONZ_DIR="$TAHOMA_DIR/toonz"
	BUILD_DIR="$TOONZ_DIR/build"
	BIN_DIR="$BUILD_DIR/bin"
	SOURCES_DIR="$TOONZ_DIR/sources"

	# Checkfiles:
	CHECK_DIR="$SCRIPT_DIR/checkfiles"
		if [ ! -e "$CHECK_DIR" ]; then 
			mkdir -p $CHECK_DIR
		fi
	CHECKFILE_PACKAGES="$CHECK_DIR/ok-packages"
	CHECKFILE_MPAINT="$CHECK_DIR/ok-opencv"
	CHECKFILE_FFMPEG="$CHECK_DIR/ok-ffmpeg"
	CHECKFILE_GPHOTO="$CHECK_DIR/ok-gphoto"
	CHECKFILE_MPAINT="$CHECK_DIR/ok-mpaint"
	CHECKFILE_RHUBARB="$CHECK_DIR/ok-rhubarb"


}

function _msg() {
	# Return a translated message based on the key and system language   
	local clave=$1 # Store the key for the requested message
	declare -A msg=( # Translation messages for different languages

		[es_INTERNET]="Este programar equiere conexión a internet"
		[en_INTERNET]="This program requires an internet connection."
		[it_INTERNET]="Questo programma richiede una connessione a Internet."
		[de_INTERNET]="Dieses Programm erfordert eine Internetverbindung."
		[fr_INTERNET]="Ce programme nécessite une connexion Internet."
		[gl_INTERNET]="Este programa require unha conexión a internet."
		[pt_INTERNET]="Este programa requer uma conexão com a internet."

		[es_PACKAGE_GESTOR_NOT_FOUND]="No se encontró un gestor de paquetes compatible."
		[en_PACKAGE_GESTOR_NOT_FOUND]="No compatible package manager found."
		[it_PACKAGE_GESTOR_NOT_FOUND]="Nessun gestore di pacchetti compatibile trovato."
		[de_PACKAGE_GESTOR_NOT_FOUND]="Kein kompatibler Paketmanager gefunden."
		[fr_PACKAGE_GESTOR_NOT_FOUND]="Aucun gestionnaire de paquets compatible trouvé."
		[gl_PACKAGE_GESTOR_NOT_FOUND]="Non se atopou un xestor de paquetes compatible."
		[pt_PACKAGE_GESTOR_NOT_FOUND]="Nenhum gerenciador de pacotes compatível encontrado."

		[es_OK_DEPENDS]="Dependencias instaladas."
		[en_OK_DEPENDS]="Dependencies installed."
		[it_OK_DEPENDS]="Dipendenze installate."
		[de_OK_DEPENDS]="Abhängigkeiten installiert."
		[fr_OK_DEPENDS]="Dépendances installées."
		[gl_OK_DEPENDS]="Dependencias instaladas."
		[pt_OK_DEPENDS]="Dependências instaladas."

		[es_ROOTCHECK]="Este script debe ejecutarse con permisos de root."
		[en_ROOTCHECK]="This script must be run as root."
		[it_ROOTCHECK]="Questo script deve essere eseguito come root."
		[de_ROOTCHECK]="Dieses Skript muss als Root ausgeführt werden."
		[fr_ROOTCHECK]="Ce script doit être exécuté en tant que root."
		[gl_ROOTCHECK]="Este script debe executarse con permisos de root."
		[pt_ROOTCHECK]="Este script deve ser executado como root."

		[es_ACEPT]="Aceptar"
		[en_ACEPT]="Accept"
		[it_ACEPT]="Accetta"
		[de_ACEPT]="Akzeptieren"
		[fr_ACEPT]="Accepter"
		[gl_ACEPT]="Aceptar"
		[pt_ACEPT]="Aceitar"

		[es_CANCEL]="Cancelar"
		[en_CANCEL]="Cancel"
		[it_CANCEL]="Annulla"
		[de_CANCEL]="Abbrechen"
		[fr_CANCEL]="Annuler"
		[gl_CANCEL]="Cancelar"
		[pt_CANCEL]="Cancelar"

		[es_WARNING]="A continuación se instalarán las dependencias necesarias."
		[en_WARNING]="The following dependencies will be installed."
		[it_WARNING]="Le seguenti dipendenze verranno installate."
		[de_WARNING]="Die folgenden Abhängigkeiten werden installiert."
		[fr_WARNING]="Les dépendances suivantes seront installées."
		[gl_WARNING]="A continuación instalaranse as dependencias necesarias."
		[pt_WARNING]="As seguintes dependências serão instaladas."

		[es_OPTION]="Opción"
		[en_OPTION]="Option"
		[it_OPTION]="Opzione"
		[de_OPTION]="Option"
		[fr_OPTION]="Option"
		[gl_OPTION]="Opción"
		[pt_OPTION]="Opção"

		[es_CANCEL]="Cancelar"
		[en_CANCEL]="Cancel"
		[it_CANCEL]="Annulla"
		[de_CANCEL]="Abbrechen"
		[fr_CANCEL]="Annuler"
		[gl_CANCEL]="Cancelar"
		[pt_CANCEL]="Cancelar"

		[es_EXIT_INSTALL]="Instalación cancelada."
		[en_EXIT_INSTALL]="Installation canceled."
		[it_EXIT_INSTALL]="Installazione annullata."
		[de_EXIT_INSTALL]="Installation abgebrochen."
		[fr_EXIT_INSTALL]="Installation annulée."
		[gl_EXIT_INSTALL]="Instalación cancelada."
		[pt_EXIT_INSTALL]="Instalação cancelada."

		[en_CLONING_OPENCV]="Cloning OpenCV."
		[es_CLONING_OPENCV]="Clonando OpenCV."
		[it_CLONING_OPENCV]="Clonando OpenCV."
		[de_CLONING_OPENCV]="OpenCV wird geklont."
		[fr_CLONING_OPENCV]="Clonage d'OpenCV."
		[gl_CLONING_OPENCV]="Clonando OpenCV."
		[pt_CLONING_OPENCV]="Clonando OpenCV."

		[en_CMAKING_OPENCV]="Cmaking OpenCV."
		[es_CMAKING_OPENCV]="Realizando el proceso de CMake para OpenCV."
		[it_CMAKING_OPENCV]="Eseguendo il processo CMake per OpenCV."
		[de_CMAKING_OPENCV]="Führe den CMake-Prozess für OpenCV aus."
		[fr_CMAKING_OPENCV]="Exécution du processus CMake pour OpenCV."
		[gl_CMAKING_OPENCV]="Realizando o proceso CMake para OpenCV."
		[pt_CMAKING_OPENCV]="Executando o processo CMake para OpenCV."

		[en_BUILDING_OPENCV]="Building OpenCV."
		[es_BUILDING_OPENCV]="Construyendo OpenCV."
		[it_BUILDING_OPENCV]="Costruendo OpenCV."
		[de_BUILDING_OPENCV]="OpenCV wird gebaut."
		[fr_BUILDING_OPENCV]="Construction d'OpenCV."
		[gl_BUILDING_OPENCV]="Construíndo OpenCV."
		[pt_BUILDING_OPENCV]="Construindo o OpenCV."

		[en_INSTALLING_OPENCV]="Installing OpenCV."
		[es_INSTALLING_OPENCV]="Instalando OpenCV."
		[it_INSTALLING_OPENCV]="Installando OpenCV."
		[de_INSTALLING_OPENCV]="OpenCV wird installiert."
		[fr_INSTALLING_OPENCV]="Installation d'OpenCV."
		[gl_INSTALLING_OPENCV]="Instalando OpenCV."
		[pt_INSTALLING_OPENCV]="Instalando o OpenCV."

		[en_CLONING_OPENH264]="Cloning openH264."
		[es_CLONING_OPENH264]="Clonando openH264."
		[it_CLONING_OPENH264]="Clonando openH264."
		[de_CLONING_OPENH264]="openH264 wird geklont."
		[fr_CLONING_OPENH264]="Clonage d'openH264."
		[gl_CLONING_OPENH264]="Clonando openH264."
		[pt_CLONING_OPENH264]="Clonando openH264."

		[en_MAKING_OPENH264]="Making openH264."
		[es_MAKING_OPENH264]="Realizando el proceso de construcción de openH264."
		[it_MAKING_OPENH264]="Eseguendo il processo di costruzione di openH264."
		[de_MAKING_OPENH264]="openH264 wird gebaut."
		[fr_MAKING_OPENH264]="Création d'openH264."
		[gl_MAKING_OPENH264]="Realizando o proceso de construción de openH264."
		[pt_MAKING_OPENH264]="Construindo o openH264."

		[en_INSTALLING_OPENH264]="Installing openH264."
		[es_INSTALLING_OPENH264]="Instalando openH264."
		[it_INSTALLING_OPENH264]="Installando openH264."
		[de_INSTALLING_OPENH264]="openH264 wird installiert."
		[fr_INSTALLING_OPENH264]="Installation de openH264."
		[gl_INSTALLING_OPENH264]="Instalando openH264."
		[pt_INSTALLING_OPENH264]="Instalando o openH264."

		[en_CLONING_FFMPEG]="Cloning ffmpeg."
		[es_CLONING_FFMPEG]="Clonando ffmpeg."
		[it_CLONING_FFMPEG]="Clonando ffmpeg."
		[de_CLONING_FFMPEG]="ffmpeg wird geklont."
		[fr_CLONING_FFMPEG]="Clonage de ffmpeg."
		[gl_CLONING_FFMPEG]="Clonando ffmpeg."
		[pt_CLONING_FFMPEG]="Clonando o ffmpeg."

		[en_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Configuring to build ffmpeg (shared)."
		[es_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Configurando para construir ffmpeg (compartido)."
		[it_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Configurando per costruire ffmpeg (condiviso)."
		[de_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Konfigurieren zum Erstellen von ffmpeg (gemeinsam)."
		[fr_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Configuration pour compiler ffmpeg (partagé)."
		[gl_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Configurando para construir ffmpeg (compartido)."
		[pt_CONFIGURING_TO_BUILD_FFMPEG_SHARED]="Configurando para compilar o ffmpeg (compartilhado)."

		[en_BUILDING_FFMPEG_SHARED]="Building ffmpeg (shared)."
		[es_BUILDING_FFMPEG_SHARED]="Construyendo ffmpeg (compartido)."
		[it_BUILDING_FFMPEG_SHARED]="Costruendo ffmpeg (condiviso)."
		[de_BUILDING_FFMPEG_SHARED]="Erstelle ffmpeg (gemeinsam)."
		[fr_BUILDING_FFMPEG_SHARED]="Compilation de ffmpeg (partagé)."
		[gl_BUILDING_FFMPEG_SHARED]="Construíndo ffmpeg (compartido)."
		[pt_BUILDING_FFMPEG_SHARED]="Compilando o ffmpeg (compartilhado)."

		[en_INSTALLING_FFMPEG_SHARED]="Installing ffmpeg (shared)."
		[es_INSTALLING_FFMPEG_SHARED]="Instalando ffmpeg (compartido)."
		[it_INSTALLING_FFMPEG_SHARED]="Installando ffmpeg (condiviso)."
		[de_INSTALLING_FFMPEG_SHARED]="Installiere ffmpeg (gemeinsam)."
		[fr_INSTALLING_FFMPEG_SHARED]="Installation de ffmpeg (partagé)."
		[gl_INSTALLING_FFMPEG_SHARED]="Instalando ffmpeg (compartido)."
		[pt_INSTALLING_FFMPEG_SHARED]="Instalando o ffmpeg (compartilhado)."

		[en_PARAMETER_O_OPENCV_SELECTED]="Parameter -o | --opencv selected."
		[es_PARAMETER_O_OPENCV_SELECTED]="Parámetro -o | --opencv seleccionado."
		[it_PARAMETER_O_OPENCV_SELECTED]="Parametro -o | --opencv selezionato."
		[de_PARAMETER_O_OPENCV_SELECTED]="Parameter -o | --opencv ausgewählt."
		[fr_PARAMETER_O_OPENCV_SELECTED]="Paramètre -o | --opencv sélectionné."
		[gl_PARAMETER_O_OPENCV_SELECTED]="Parámetro -o | --opencv seleccionado."
		[pt_PARAMETER_O_OPENCV_SELECTED]="Parâmetro -o | --opencv selecionado."

		[en_PARAMETER_O_RHUBARB_SELECTED]="Parameter -r | --rhubarb selected."
		[es_PARAMETER_O_RHUBARB_SELECTED]="Parámetro -r | --rhubarb seleccionado."
		[it_PARAMETER_O_RHUBARB_SELECTED]="Parametro -r | --rhubarb selezionato."
		[de_PARAMETER_O_RHUBARB_SELECTED]="Parameter -r | --rhubarb ausgewählt."
		[fr_PARAMETER_O_RHUBARB_SELECTED]="Paramètre -r | --rhubarb sélectionné."
		[gl_PARAMETER_O_RHUBARB_SELECTED]="Parámetro -r | --rhubarb seleccionado."
		[pt_PARAMETER_O_RHUBARB_SELECTED]="Parâmetro -r | --rhubarb selecionado."

		[en_PARAMETER_F_FFMPEG_SELECTED]="Parameter -f | --ffmpeg selected."
		[es_PARAMETER_F_FFMPEG_SELECTED]="Parámetro -f | --ffmpeg seleccionado."
		[it_PARAMETER_F_FFMPEG_SELECTED]="Parametro -f | --ffmpeg selezionato."
		[de_PARAMETER_F_FFMPEG_SELECTED]="Parameter -f | --ffmpeg ausgewählt."
		[fr_PARAMETER_F_FFMPEG_SELECTED]="Paramètre -f | --ffmpeg sélectionné."
		[gl_PARAMETER_F_FFMPEG_SELECTED]="Parámetro -f | --ffmpeg seleccionado."
		[pt_PARAMETER_F_FFMPEG_SELECTED]="Parâmetro -f | --ffmpeg selecionado."

		[es_PARAMETER_GPHOTO_SELECTED]="Parámetro -g | --gphoto seleccionado."
		[en_PARAMETER_GPHOTO_SELECTED]="Parameter -g | --gphoto selected."
		[it_PARAMETER_GPHOTO_SELECTED]="Parametro -g | --gphoto selezionato."
		[de_PARAMETER_GPHOTO_SELECTED]="Parameter -g | --gphoto ausgewählt."
		[fr_PARAMETER_GPHOTO_SELECTED]="Paramètre -g | --gphoto sélectionné."
		[gl_PARAMETER_GPHOTO_SELECTED]="Parámetro -g | --gphoto seleccionado."
		[pt_PARAMETER_GPHOTO_SELECTED]="Parâmetro -g | --gphoto selecionado."

		[es_PARAMETER_MPAINT_SELECTED]="Parámetro -m | --mypaint seleccionado."
		[en_PARAMETER_MPAINT_SELECTED]="Parameter -m | --mypaint selected."
		[it_PARAMETER_MPAINT_SELECTED]="Parametro -m | --mypaint selezionato."
		[de_PARAMETER_MPAINT_SELECTED]="Parameter -m | --mypaint ausgewählt."
		[fr_PARAMETER_MPAINT_SELECTED]="Paramètre -m | --mypaint sélectionné."
		[gl_PARAMETER_MPAINT_SELECTED]="Parámetro -m | --mypaint seleccionado."
		[pt_PARAMETER_MPAINT_SELECTED]="Parâmetro -m | --mypaint selecionado."

		[es_ALREADY_COMPILED]="ya fue compilado. Se omitirá su compilación."
		[en_ALREADY_COMPILED]="it has already been compiled. Its compilation will be skipped."
		[it_ALREADY_COMPILED]="è già stato compilato. La sua compilazione sarà saltata."
		[de_ALREADY_COMPILED]="es wurde bereits kompiliert. Die Kompilierung wird übersprungen."
		[fr_ALREADY_COMPILED]="il a déjà été compilé. Sa compilation sera ignorée."
		[gl_ALREADY_COMPILED]="xa foi compilado. A súa compilación será omitiu."
		[pt_ALREADY_COMPILED]="já foi compilado. Sua compilação será ignorada."

		[es_CLONING_LIBGPHOTO2]="Clonando libgphoto2"
		[en_CLONING_LIBGPHOTO2]="Cloning libgphoto2"
		[it_CLONING_LIBGPHOTO2]="Clonazione di libgphoto2"
		[de_CLONING_LIBGPHOTO2]="Cloning libgphoto2"
		[fr_CLONING_LIBGPHOTO2]="Clonage de libgphoto2"
		[gl_CLONING_LIBGPHOTO2]="Clonando libgphoto2"
		[pt_CLONING_LIBGPHOTO2]="Clonando libgphoto2"

		[es_CONFIGURING_LIBGPHOTO2]="Configurando libgphoto2"
		[en_CONFIGURING_LIBGPHOTO2]="Configuring libgphoto2"
		[it_CONFIGURING_LIBGPHOTO2]="Configurando libgphoto2"
		[de_CONFIGURING_LIBGPHOTO2]="Konfigurieren von libgphoto2"
		[fr_CONFIGURING_LIBGPHOTO2]="Configuration de libgphoto2"
		[gl_CONFIGURING_LIBGPHOTO2]="Configurando libgphoto2"
		[pt_CONFIGURING_LIBGPHOTO2]="Configurando libgphoto2"

		[es_MAKING_LIBGPHOTO2]="Compilando libgphoto2"
		[en_MAKING_LIBGPHOTO2]="Making libgphoto2"
		[it_MAKING_LIBGPHOTO2]="Creando libgphoto2"
		[de_MAKING_LIBGPHOTO2]="Erstelle libgphoto2"
		[fr_MAKING_LIBGPHOTO2]="Création de libgphoto2"
		[gl_MAKING_LIBGPHOTO2]="Facendo libgphoto2"
		[pt_MAKING_LIBGPHOTO2]="Compilando libgphoto2"

		[es_GNUTLS_NOT_FOUND]="ERROR: pkg-config no encuentra GnuTLS"
		[en_GNUTLS_NOT_FOUND]="ERROR: pkg-config cannot find GnuTLS"
		[it_GNUTLS_NOT_FOUND]="ERRORE: pkg-config non trova GnuTLS"
		[de_GNUTLS_NOT_FOUND]="FEHLER: pkg-config kann GnuTLS nicht finden"
		[fr_GNUTLS_NOT_FOUND]="ERREUR : pkg-config ne trouve pas GnuTLS"
		[gl_GNUTLS_NOT_FOUND]="ERRO: pkg-config non atopa GnuTLS"
		[pt_GNUTLS_NOT_FOUND]="ERRO: pkg-config não encontra GnuTLS"

		[es_INSTALLING_LIBGPHOTO2]="Instalando libgphoto2"
		[en_INSTALLING_LIBGPHOTO2]="Installing libgphoto2"
		[it_INSTALLING_LIBGPHOTO2]="Installando libgphoto2"
		[de_INSTALLING_LIBGPHOTO2]="Installiere libgphoto2"
		[fr_INSTALLING_LIBGPHOTO2]="Installation de libgphoto2"
		[gl_INSTALLING_LIBGPHOTO2]="Instalando libgphoto2"
		[pt_INSTALLING_LIBGPHOTO2]="Instalando libgphoto2"

		[es_CLONING_LIBMYPAINT]="Clonando libmypaint"
		[en_CLONING_LIBMYPAINT]="Cloning libmypaint"
		[it_CLONING_LIBMYPAINT]="Clonando libmypaint"
		[de_CLONING_LIBMYPAINT]="Cloning libmypaint"
		[fr_CLONING_LIBMYPAINT]="Clonage de libmypaint"
		[gl_CLONING_LIBMYPAINT]="Clonando libmypaint"
		[pt_CLONING_LIBMYPAINT]="Clonando libmypaint"

		[es_GENERATING_LIBMYPAINT_ENVIRONMENT]="Generando entorno de libmypaint"
		[en_GENERATING_LIBMYPAINT_ENVIRONMENT]="Generating libmypaint environment"
		[it_GENERATING_LIBMYPAINT_ENVIRONMENT]="Generando l'ambiente di libmypaint"
		[de_GENERATING_LIBMYPAINT_ENVIRONMENT]="Generiere libmypaint Umgebung"
		[fr_GENERATING_LIBMYPAINT_ENVIRONMENT]="Génération de l'environnement libmypaint"
		[gl_GENERATING_LIBMYPAINT_ENVIRONMENT]="Xenerando o entorno de libmypaint"
		[pt_GENERATING_LIBMYPAINT_ENVIRONMENT]="Gerando o ambiente do libmypaint"

		[es_CONFIGURING_LIBMYPAINT_BUILD]="Configurando la construcción de libmypaint"
		[en_CONFIGURING_LIBMYPAINT_BUILD]="Configuring libmypaint build"
		[it_CONFIGURING_LIBMYPAINT_BUILD]="Configurando la costruzione di libmypaint"
		[de_CONFIGURING_LIBMYPAINT_BUILD]="Konfigurieren des libmypaint Builds"
		[fr_CONFIGURING_LIBMYPAINT_BUILD]="Configuration de la construction de libmypaint"
		[gl_CONFIGURING_LIBMYPAINT_BUILD]="Configurando a construción de libmypaint"
		[pt_CONFIGURING_LIBMYPAINT_BUILD]="Configurando a construção do libmypaint"

		[es_BUILDING_LIBMYPAINT]="Construyendo libmypaint"
		[en_BUILDING_LIBMYPAINT]="Building libmypaint"
		[it_BUILDING_LIBMYPAINT]="Costruendo libmypaint"
		[de_BUILDING_LIBMYPAINT]="Bauen von libmypaint"
		[fr_BUILDING_LIBMYPAINT]="Construction de libmypaint"
		[gl_BUILDING_LIBMYPAINT]="Construíndo libmypaint"
		[pt_BUILDING_LIBMYPAINT]="Construindo o libmypaint"

		[es_INSTALLING_LIBMYPAINT]="Instalando libmypaint"
		[en_INSTALLING_LIBMYPAINT]="Installing libmypaint"
		[it_INSTALLING_LIBMYPAINT]="Installazione di libmypaint"
		[de_INSTALLING_LIBMYPAINT]="Installiere libmypaint"
		[fr_INSTALLING_LIBMYPAINT]="Installation de libmypaint"
		[gl_INSTALLING_LIBMYPAINT]="Instalando libmypaint"
		[pt_INSTALLING_LIBMYPAINT]="Instalando o libmypaint"

		[es_LIBRARIES_TO_COMPILE]="Se compilarán las siguientes librerías:"
		[en_LIBRARIES_TO_COMPILE]="The following libraries will be compiled:"
		[it_LIBRARIES_TO_COMPILE]="Le seguenti librerie verranno compilate:"
		[de_LIBRARIES_TO_COMPILE]="Die folgenden Bibliotheken werden kompiliert:"
		[fr_LIBRARIES_TO_COMPILE]="Les bibliothèques suivantes seront compilées :"
		[gl_LIBRARIES_TO_COMPILE]="Compilaranse as seguintes bibliotecas:"
		[pt_LIBRARIES_TO_COMPILE]="As seguintes bibliotecas serão compiladas:"

		[es_CONTINUE_COMPILATION]="¿Deseas continuar con la compilación de las librerías seleccionadas?"
		[en_CONTINUE_COMPILATION]="Do you want to continue with the compilation of the selected libraries?"
		[it_CONTINUE_COMPILATION]="Vuoi continuare con la compilazione delle librerie selezionate?"
		[de_CONTINUE_COMPILATION]="Möchten Sie mit der Kompilierung der ausgewählten Bibliotheken fortfahren?"
		[fr_CONTINUE_COMPILATION]="Voulez-vous continuer la compilation des bibliothèques sélectionnées ?"
		[gl_CONTINUE_COMPILATION]="Desexas continuar coa compilación das bibliotecas seleccionadas?"
		[pt_CONTINUE_COMPILATION]="Deseja continuar com a compilação das bibliotecas selecionadas?"

		[es_NO_ADDITIONAL_LIBRARIES]="Sin librerías adicionales para compilar."
		[en_NO_ADDITIONAL_LIBRARIES]="No additional libraries to compile."
		[it_NO_ADDITIONAL_LIBRARIES]="Nessuna libreria aggiuntiva da compilare."
		[de_NO_ADDITIONAL_LIBRARIES]="Keine zusätzlichen Bibliotheken zu kompilieren."
		[fr_NO_ADDITIONAL_LIBRARIES]="Aucune bibliothèque supplémentaire à compiler."
		[gl_NO_ADDITIONAL_LIBRARIES]="Sen bibliotecas adicionais para compilar."
		[pt_NO_ADDITIONAL_LIBRARIES]="Sem bibliotecas adicionais para compilar."

		[en_USAGE]="Usage: $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint] to install additional libraries.\n [-c | --clear] to delete check files and the local tahoma2d repository folder."
		[es_USAGE]="Uso: $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint] para instalar librerías adicionales.\n [-c | --clear] para eliminar checkfiles y carpeta local de repositorio tahoma2d."
		[it_USAGE]="Uso: $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint] per installare librerie aggiuntive.\n [-c | --clear] per eliminare i file di controllo e la cartella locale del repository tahoma2d."
		[de_USAGE]="Verwendung: $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint], um zusätzliche Bibliotheken zu installieren.\n [-c | --clear], um Prüfdateien und den lokalen tahoma2d-Repository-Ordner zu löschen."
		[fr_USAGE]="Utilisation : $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint] pour installer des bibliothèques supplémentaires.\n [-c | --clear] pour supprimer les fichiers de vérification et le dossier du dépôt local tahoma2d."
		[gl_USAGE]="Uso: $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint] para instalar librarías adicionais.\n [-c | --clear] para eliminar os ficheiros de verificación e o cartafol do repositorio local tahoma2d."
		[pt_USAGE]="Uso: $0 [-o | --opencv] [-f | --ffmpeg] [-g | --gphoto] [-m | --mpaint] para instalar bibliotecas adicionais.\n [-c | --clear] para excluir arquivos de verificação e a pasta do repositório local tahoma2d."

		[es_CLEAR_DETECTED]="Se ha detectado el argumento -c | --clear."
		[en_CLEAR_DETECTED]="The -c | --clear argument has been detected."
		[it_CLEAR_DETECTED]="È stato rilevato l'argomento -c | --clear."
		[de_CLEAR_DETECTED]="Das Argument -c | --clear wurde erkannt."
		[fr_CLEAR_DETECTED]="L'argument -c | --clear a été détecté."
		[gl_CLEAR_DETECTED]="Detectouse o argumento -c | --clear."
		[pt_CLEAR_DETECTED]="O argumento -c | --clear foi detectado."

		[es_CLEAR_WARNING]="Esto borrará el repositorio local y los archivos de comprobación."
		[en_CLEAR_WARNING]="This will delete the local repository and check files."
		[it_CLEAR_WARNING]="Questo eliminerà il repository locale e i file di controllo."
		[de_CLEAR_WARNING]="Dadurch werden das lokale Repository und die Prüfdateien gelöscht."
		[fr_CLEAR_WARNING]="Cela supprimera le dépôt local et les fichiers de vérification."
		[gl_CLEAR_WARNING]="Isto eliminará o repositorio local e os ficheiros de comprobación."
		[pt_CLEAR_WARNING]="Isso excluirá o repositório local e os arquivos de verificação."

		[es_PROCEED_WITH_CLEAR]="¿Deseas continuar con el reseteo?"
		[en_PROCEED_WITH_CLEAR]="Do you want to proceed with the reset?"
		[it_PROCEED_WITH_CLEAR]="Vuoi procedere con il reset?"
		[de_PROCEED_WITH_CLEAR]="Möchten Sie mit dem Reset fortfahren?"
		[fr_PROCEED_WITH_CLEAR]="Voulez-vous continuer la réinitialisation?"
		[gl_PROCEED_WITH_CLEAR]="Desexas continuar co restablecemento?"
		[pt_PROCEED_WITH_CLEAR]="Deseja continuar com a redefinição?"

		[es_NO_CHECKFILES_TO_DELETE]="No se detectaron archivos de comprobación para eliminar."
		[en_NO_CHECKFILES_TO_DELETE]="No check files detected to delete."
		[it_NO_CHECKFILES_TO_DELETE]="Nessun file di controllo rilevato da eliminare."
		[de_NO_CHECKFILES_TO_DELETE]="Keine Prüfdateien zum Löschen gefunden."
		[fr_NO_CHECKFILES_TO_DELETE]="Aucun fichier de vérification détecté à supprimer."
		[gl_NO_CHECKFILES_TO_DELETE]="Non se detectaron ficheiros de comprobación para eliminar."
		[pt_NO_CHECKFILES_TO_DELETE]="Nenhum arquivo de verificação detectado para excluir."

		[es_DELETING_TAHOMA_DIR]="Eliminando carpeta tahoma2d..."
		[en_DELETING_TAHOMA_DIR]="Deleting tahoma2d directory..."
		[it_DELETING_TAHOMA_DIR]="Eliminazione della directory tahoma2d..."
		[de_DELETING_TAHOMA_DIR]="Lösche tahoma2d-Verzeichnis..."
		[fr_DELETING_TAHOMA_DIR]="Suppression du répertoire tahoma2d..."
		[gl_DELETING_TAHOMA_DIR]="Eliminando o directorio tahoma2d..."
		[pt_DELETING_TAHOMA_DIR]="Excluindo o diretório tahoma2d..."

		[es_NO_TAHOMA_DIR_TO_DELETE]="No se detectó la carpeta tahoma2d para eliminar."
		[en_NO_TAHOMA_DIR_TO_DELETE]="No tahoma2d directory detected to delete."
		[it_NO_TAHOMA_DIR_TO_DELETE]="Nessuna directory tahoma2d rilevata da eliminare."
		[de_NO_TAHOMA_DIR_TO_DELETE]="Kein tahoma2d-Verzeichnis zum Löschen gefunden."
		[fr_NO_TAHOMA_DIR_TO_DELETE]="Aucun répertoire tahoma2d détecté à supprimer."
		[gl_NO_TAHOMA_DIR_TO_DELETE]="Non se detectou o directorio tahoma2d para eliminar."
		[pt_NO_TAHOMA_DIR_TO_DELETE]="Nenhum diretório tahoma2d detectado para excluir."

		[es_CLEAR_COMPLETED]="Reseteo completado."
		[en_CLEAR_COMPLETED]="Reset completed."
		[it_CLEAR_COMPLETED]="Reset completato."
		[de_CLEAR_COMPLETED]="Reset abgeschlossen."
		[fr_CLEAR_COMPLETED]="Réinitialisation terminée."
		[gl_CLEAR_COMPLETED]="Restablecemento completado."
		[pt_CLEAR_COMPLETED]="Redefinição concluída."

		[es_CLEAR_NOT_ALLOWED_HERE]="Sólo es posible borrar tahoma2d cuando este script\nse encuentra al mismo nivel que la carpeta."
		[en_CLEAR_NOT_ALLOWED_HERE]="Tahoma2D can only be deleted when this script\nis at the same level as the folder."
		[it_CLEAR_NOT_ALLOWED_HERE]="Tahoma2D può essere eliminato solo quando questo script\nsi trova allo stesso livello della cartella."
		[de_CLEAR_NOT_ALLOWED_HERE]="Tahoma2D kann nur gelöscht werden, wenn sich dieses Skript\nauf derselben Ebene wie der Ordner befindet."
		[fr_CLEAR_NOT_ALLOWED_HERE]="Tahoma2D ne peut être supprimé que lorsque ce script\nse trouve au même niveau que le dossier."
		[gl_CLEAR_NOT_ALLOWED_HERE]="Só é posible borrar Tahoma2D cando este script\nse atopa ao mesmo nivel que o cartafol."
		[pt_CLEAR_NOT_ALLOWED_HERE]="O Tahoma2D só pode ser excluído quando este script\nestá no mesmo nível da pasta."

		[es_ENTER_NORMAL_USER_NAME]="Introduce el nombre del usuario normal que ejecutará linux_build.sh (no root):"
		[en_ENTER_NORMAL_USER_NAME]="Enter the name of the normal user who will run linux_build.sh (not root):"
		[it_ENTER_NORMAL_USER_NAME]="Inserisci il nome dell'utente normale che eseguirà linux_build.sh (non root):"
		[de_ENTER_NORMAL_USER_NAME]="Geben Sie den Namen des normalen Benutzers ein, der linux_build.sh ausführen wird (nicht root):"
		[fr_ENTER_NORMAL_USER_NAME]="Entrez le nom de l'utilisateur normal qui exécutera linux_build.sh (pas root) :"
		[gl_ENTER_NORMAL_USER_NAME]="Introduce o nome do usuario normal que executará linux_build.sh (non root):"
		[pt_ENTER_NORMAL_USER_NAME]="Digite o nome do usuário normal que executará linux_build.sh (não root):"

		[es_USERNAME_CANNOT_BE_EMPTY]="Error: El nombre de usuario no puede estar vacío."
		[en_USERNAME_CANNOT_BE_EMPTY]="Error: The username cannot be empty."
		[it_USERNAME_CANNOT_BE_EMPTY]="Errore: Il nome utente non può essere vuoto."
		[de_USERNAME_CANNOT_BE_EMPTY]="Fehler: Der Benutzername darf nicht leer sein."
		[fr_USERNAME_CANNOT_BE_EMPTY]="Erreur : Le nom d'utilisateur ne peut pas être vide."
		[gl_USERNAME_CANNOT_BE_EMPTY]="Erro: O nome de usuario non pode estar baleiro."
		[pt_USERNAME_CANNOT_BE_EMPTY]="Erro: O nome de usuário não pode estar vazio."

		[es_PROPERTY_CHANGED]="'$TAHOMA_DIR' propiedad de la carpeta cambiada a '$USERNAME'."
		[en_PROPERTY_CHANGED]="'$TAHOMA_DIR' folder property changed to '$USERNAME'."
		[it_PROPERTY_CHANGED]="'$TAHOMA_DIR' proprietà della cartella cambiata a '$USERNAME'."
		[de_PROPERTY_CHANGED]="'$TAHOMA_DIR' Ordnersymbol geändert auf '$USERNAME'."
		[fr_PROPERTY_CHANGED]="'$TAHOMA_DIR' propriété du dossier modifiée à '$USERNAME'."
		[gl_PROPERTY_CHANGED]="'$TAHOMA_DIR' propiedade da carpeta cambiada a '$USERNAME'."
		[pt_PROPERTY_CHANGED]="'$TAHOMA_DIR' propriedade da pasta alterada para '$USERNAME'."

		[es_FOLDER_DOES_NOT_EXIST]="La carpeta '$TAHOMA_DIR' no existe."
		[en_FOLDER_DOES_NOT_EXIST]="The folder '$TAHOMA_DIR' does not exist."
		[it_FOLDER_DOES_NOT_EXIST]="La cartella '$TAHOMA_DIR' non esiste."
		[de_FOLDER_DOES_NOT_EXIST]="Der Ordner '$TAHOMA_DIR' existiert nicht."
		[fr_FOLDER_DOES_NOT_EXIST]="Le dossier '$TAHOMA_DIR' n'existe pas."
		[gl_FOLDER_DOES_NOT_EXIST]="A carpeta '$TAHOMA_DIR' non existe."
		[pt_FOLDER_DOES_NOT_EXIST]="A pasta '$TAHOMA_DIR' não existe."

		[es_REPOSITORY_NEEDS_CLONING]="Se necesita clonar el repositorio: ${REPO_URL}\ndefinido en fichero var_local para obtener sources de las librerías a compilar."
		[en_REPOSITORY_NEEDS_CLONING]="The repository needs to be cloned: ${REPO_URL}\ndefined in var_local file to obtain sources of the libraries to compile.."
		[it_REPOSITORY_NEEDS_CLONING]="È necessario clonare il repository: ${REPO_URL}\ndefinito nel file var_local per ottenere le sorgenti delle librerie da compilare."
		[de_REPOSITORY_NEEDS_CLONING]="Das Repository muss geklont werden: ${REPO_URL}\ndefiniert in der Datei var_local, um Quellen der Bibliotheken zum Kompilieren zu erhalten."
		[fr_REPOSITORY_NEEDS_CLONING]="Le dépôt doit être cloné : ${REPO_URL}\ndéfini dans le fichier var_local pour obtenir les sources des bibliothèques à compiler."
		[gl_REPOSITORY_NEEDS_CLONING]="Necesítase clonar o repositorio: ${REPO_URL}\ndefinido no ficheiro var_local para obter fontes das bibliotecas a compilar."
		[pt_REPOSITORY_NEEDS_CLONING]="É necessário clonar o repositório: ${REPO_URL}\ndefinido no ficheiro var_local para obter as fontes das bibliotecas a compilar."

		[es_CONTINUE_REPOSITORY_CLONING]="¿Deseas continuar con la clonación del repositorio?"
		[en_CONTINUE_REPOSITORY_CLONING]="Do you want to continue with the repository cloning?"
		[it_CONTINUE_REPOSITORY_CLONING]="Vuoi continuare con il cloning del repository?"
		[de_CONTINUE_REPOSITORY_CLONING]="Möchten Sie mit der Repository-Klonung fortfahren?"
		[fr_CONTINUE_REPOSITORY_CLONING]="Voulez-vous continuer avec le clonage du dépôt ?"
		[gl_CONTINUE_REPOSITORY_CLONING]="Desexa continuar coa clonación do repositorio?"
		[pt_CONTINUE_REPOSITORY_CLONING]="Deseja continuar com a clonagem do repositório?"

		[es_CLONING_REPOSITORY]="Clonando el repositorio..."
		[en_CLONING_REPOSITORY]="Cloning the repository..."
		[it_CLONING_REPOSITORY]="Clonando il repository..."
		[de_CLONING_REPOSITORY]="Repository wird geklont..."
		[fr_CLONING_REPOSITORY]="Clonage du dépôt en cours..."
		[gl_CLONING_REPOSITORY]="Clonando o repositorio..."
		[pt_CLONING_REPOSITORY]="Clonando o repositório..."

		[es_LISTING_AVAILABLE_BRANCHES]="Listando ramas disponibles en el repositorio"
		[en_LISTING_AVAILABLE_BRANCHES]="Listing available branches in the repository"
		[it_LISTING_AVAILABLE_BRANCHES]="Elencando i rami disponibili nel repository"
		[de_LISTING_AVAILABLE_BRANCHES]="Auflisten der verfügbaren Zweige im Repository"
		[fr_LISTING_AVAILABLE_BRANCHES]="Liste des branches disponibles dans le dépôt"
		[gl_LISTING_AVAILABLE_BRANCHES]="Listando ramas dispoñibles no repositorio"
		[pt_LISTING_AVAILABLE_BRANCHES]="Listando os ramos disponíveis no repositório"

		[es_SELECT_BRANCH_OR_EXIT]="Selecciona una rama para descargar.\nEsta será la rama sobre la cual trabajará linux_build.sh. O 'Salir' para terminar:"
		[en_SELECT_BRANCH_OR_EXIT]="Select a branch to download.\nThis will be the branch that linux_build.sh will work on. Or 'Exit' to finish:"
		[it_SELECT_BRANCH_OR_EXIT]="Seleziona un ramo da scaricare.\nQuesto sarà il ramo su cui lavorerà linux_build.sh. O 'Esci' per terminare:"
		[de_SELECT_BRANCH_OR_EXIT]="Wählen Sie einen Zweig zum Herunterladen.\nDies wird der Zweig sein, an dem linux_build.sh arbeiten wird. Oder 'Exit', um zu beenden:"
		[fr_SELECT_BRANCH_OR_EXIT]="Sélectionnez une branche à télécharger.\nCe sera la branche sur laquelle travaillera linux_build.sh. Ou 'Exit' pour terminer :"
		[gl_SELECT_BRANCH_OR_EXIT]="Selecciona unha rama para descargar.\nEsta será a rama sobre a que traballará linux_build.sh. Ou 'Saír' para rematar:"
		[pt_SELECT_BRANCH_OR_EXIT]="Selecione um ramo para baixar.\nEste será o ramo no qual o linux_build.sh trabalhará. Ou 'Exit' para terminar:"

		[es_EXIT]="Salir"
		[en_EXIT]="Exit"
		[it_EXIT]="Esci"
		[de_EXIT]="Beenden"
		[fr_EXIT]="Sortir"
		[gl_EXIT]="Saír"
		[pt_EXIT]="Sair"

		[es_TAHOMA2D_OWNED_BY_ROOT]="La carpeta tahoma2d pertenece a root.\n\n"
		[en_TAHOMA2D_OWNED_BY_ROOT]="The tahoma2d folder is owned by root.\n\n"
		[it_TAHOMA2D_OWNED_BY_ROOT]="La cartella tahoma2d è di proprietà di root.\n\n"
		[de_TAHOMA2D_OWNED_BY_ROOT]="Der Ordner tahoma2d gehört zu root.\n\n"
		[fr_TAHOMA2D_OWNED_BY_ROOT]="Le dossier tahoma2d appartient à root.\n\n"
		[gl_TAHOMA2D_OWNED_BY_ROOT]="A carpeta tahoma2d pertence a root.\n\n"
		[pt_TAHOMA2D_OWNED_BY_ROOT]="A pasta tahoma2d pertence ao root.\n\n"

		[es_LINUX_BUILD_SH_NO_ROOT]="Sería conveniente que linux_build.sh sea ejecutado por un usuario normal\nque necesitará poder acceder a la carpeta.\n\n"
		[en_LINUX_BUILD_SH_NO_ROOT]="It would be advisable to run linux_build.sh as a normal user\nwho will need access to the folder.\n\n"
		[it_LINUX_BUILD_SH_NO_ROOT]="Sarebbe consigliabile eseguire linux_build.sh come utente normale\nche avrà bisogno di accedere alla cartella.\n\n"
		[de_LINUX_BUILD_SH_NO_ROOT]="Es wäre ratsam, linux_build.sh als normalen Benutzer auszuführen,\nder Zugriff auf den Ordner benötigt.\n\n"
		[fr_LINUX_BUILD_SH_NO_ROOT]="Il serait conseillé d'exécuter linux_build.sh en tant qu'utilisateur normal\nqui aura besoin d'accéder au dossier.\n\n"
		[gl_LINUX_BUILD_SH_NO_ROOT]="Sería recomendable executar linux_build.sh como un usuario normal\nque necesitará acceso á carpeta.\n\n"
		[pt_LINUX_BUILD_SH_NO_ROOT]="Seria aconselhável executar o linux_build.sh como um usuário normal\nque precisará de acesso à pasta.\n\n"

		[es_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="Podemos cambiar el propietario de la carpeta tahoma2d a un usuario normal.\n\n"
		[en_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="We can change the ownership of the tahoma2d folder to a normal user.\n\n"
		[it_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="Possiamo cambiare la proprietà della cartella tahoma2d a un utente normale.\n\n"
		[de_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="Wir können den Besitz des tahoma2d-Ordners auf einen normalen Benutzer ändern.\n\n"
		[fr_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="Nous pouvons changer la propriété du dossier tahoma2d à un utilisateur normal.\n\n"
		[gl_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="Podemos cambiar a propiedade da carpeta tahoma2d a un usuario normal.\n\n"
		[pt_WOULD_YOU_LIKE_TO_ENTER_NORMAL_USERNAME]="Podemos alterar a propriedade da pasta tahoma2d para um usuário normal.\n\n"

		[es_ENTER_NORMAL_USER]="Ingresar usuario normal"
		[en_ENTER_NORMAL_USER]="Enter normal user"
		[it_ENTER_NORMAL_USER]="Inserisci utente normale"
		[de_ENTER_NORMAL_USER]="Geben Sie den normalen Benutzer ein"
		[fr_ENTER_NORMAL_USER]="Entrez un utilisateur normal"
		[gl_ENTER_NORMAL_USER]="Introducir usuario normal"
		[pt_ENTER_NORMAL_USER]="Digite o usuário normal"

		[es_IGNORE_WARNING]="Ignorar advertencia"
		[en_IGNORE_WARNING]="Ignore warning"
		[it_IGNORE_WARNING]="Ignora avviso"
		[de_IGNORE_WARNING]="Warnung ignorieren"
		[fr_IGNORE_WARNING]="Ignorer l'avertissement"
		[gl_IGNORE_WARNING]="Ignorar advertencia"
		[pt_IGNORE_WARNING]="Ignorar aviso"
		
		[es_NEW_USER]="Usuario normal: "
		[en_NEW_USER]="Normal user: "
		[it_NEW_USER]="Utente normale: "
		[de_NEW_USER]="Normaler Benutzer: "
		[fr_NEW_USER]="Utilisateur normal : "
		[gl_NEW_USER]="Usuario normal: "
		[pt_NEW_USER]="Usuário normal: "

		[es_EXITING_CLONING_PROCESS]="Saliendo del proceso de clonación."
		[en_EXITING_CLONING_PROCESS]="Exiting the cloning process."
		[it_EXITING_CLONING_PROCESS]="Uscita dal processo di clonazione."
		[de_EXITING_CLONING_PROCESS]="Verlassen des Klonvorgangs."
		[fr_EXITING_CLONING_PROCESS]="Sortie du processus de clonage."
		[gl_EXITING_CLONING_PROCESS]="Saíndo do proceso de clonación."
		[pt_EXITING_CLONING_PROCESS]="Saindo do processo de clonagem."

		[es_SELECTED_BRANCH]="Rama seleccionada: $branch"
		[en_SELECTED_BRANCH]="Selected branch: $branch"
		[it_SELECTED_BRANCH]="Ramo selezionato: $branch"
		[de_SELECTED_BRANCH]="Ausgewählter Zweig: $branch"
		[fr_SELECTED_BRANCH]="Branche sélectionnée : $branch"
		[gl_SELECTED_BRANCH]="Rama seleccionada: $branch"
		[pt_SELECTED_BRANCH]="Ramo selecionado: $branch"

		[es_INVALID_SELECTION_TRY_AGAIN]="Selección no válida, intenta de nuevo."
		[en_INVALID_SELECTION_TRY_AGAIN]="Invalid selection, please try again."
		[it_INVALID_SELECTION_TRY_AGAIN]="Selezione non valida, riprova."
		[de_INVALID_SELECTION_TRY_AGAIN]="Ungültige Auswahl, bitte versuche es erneut."
		[fr_INVALID_SELECTION_TRY_AGAIN]="Sélection invalide, veuillez réessayer."
		[gl_INVALID_SELECTION_TRY_AGAIN]="Selección non válida, intenta de novo."
		[pt_INVALID_SELECTION_TRY_AGAIN]="Seleção inválida, tente novamente."

		[es_INVALID_OPTION_TRY_AGAIN]="Opción no válida, intenta de nuevo."
		[en_INVALID_OPTION_TRY_AGAIN]="Invalid option, please try again."
		[it_INVALID_OPTION_TRY_AGAIN]="Opzione non valida, riprova."
		[de_INVALID_OPTION_TRY_AGAIN]="Ungültige Option, bitte versuche es erneut."
		[fr_INVALID_OPTION_TRY_AGAIN]="Option invalide, veuillez réessayer."
		[gl_INVALID_OPTION_TRY_AGAIN]="Opción non válida, intenta de novo."
		[pt_INVALID_OPTION_TRY_AGAIN]="Opção inválida, tente novamente."

		[es_OPENCV_BUILD_ERROR]="Error en la compilación de OpenCV"
		[en_OPENCV_BUILD_ERROR]="OpenCV build error"
		[it_OPENCV_BUILD_ERROR]="Errore nella compilazione di OpenCV"
		[de_OPENCV_BUILD_ERROR]="Fehler beim Kompilieren von OpenCV"
		[fr_OPENCV_BUILD_ERROR]="Erreur de compilation d'OpenCV"
		[gl_OPENCV_BUILD_ERROR]="Erro na compilación de OpenCV"
		[pt_OPENCV_BUILD_ERROR]="Erro na compilação do OpenCV"

		[es_FFMPEG_BUILD_ERROR]="Error en la compilación de FFmpeg"
		[en_FFMPEG_BUILD_ERROR]="FFmpeg build error"
		[it_FFMPEG_BUILD_ERROR]="Errore nella compilazione di FFmpeg"
		[de_FFMPEG_BUILD_ERROR]="Fehler beim Kompilieren von FFmpeg"
		[fr_FFMPEG_BUILD_ERROR]="Erreur de compilation d'FFmpeg"
		[gl_FFMPEG_BUILD_ERROR]="Erro na compilación de FFmpeg"
		[pt_FFMPEG_BUILD_ERROR]="Erro na compilação do FFmpeg"

		[es_GPHOTO_BUILD_ERROR]="Error en la compilación de gphoto2"
		[en_GPHOTO_BUILD_ERROR]="gphoto2 build error"
		[it_GPHOTO_BUILD_ERROR]="Errore nella compilazione di gphoto2"
		[de_GPHOTO_BUILD_ERROR]="Fehler beim Kompilieren von gphoto2"
		[fr_GPHOTO_BUILD_ERROR]="Erreur de compilation d'gphoto2"
		[gl_GPHOTO_BUILD_ERROR]="Erro na compilación de gphoto2"
		[pt_GPHOTO_BUILD_ERROR]="Erro na compilação do gphoto2"

		[es_MPAINT_BUILD_ERROR]="Error en la compilación de libMyPaint"
		[en_MPAINT_BUILD_ERROR]="libMyPaint build error"
		[it_MPAINT_BUILD_ERROR]="Errore nella compilazione di libMyPaint"
		[de_MPAINT_BUILD_ERROR]="Fehler beim Kompilieren von libMyPaint"
		[fr_MPAINT_BUILD_ERROR]="Erreur de compilation d'libMyPaint"
		[gl_MPAINT_BUILD_ERROR]="Erro na compilación de libMyPaint"
		[pt_MPAINT_BUILD_ERROR]="Erro na compilação do libMyPaint"


	)

	local idioma=$(echo $LANG | cut -d_ -f1)
	local mensaje=${msg[${idioma}_$clave]:-${msg[en_$clave]}}

	printf "%s" "$mensaje"
}

function _cloneIf() {
	# Clone the repository when you need it to compile libraries.
		if [ ! -d "$THIRDPARTY_DIR" ]; then
			# Show message and instructions
			echo -e "\n$(_msg REPOSITORY_NEEDS_CLONING)"

			# Ask the user if they want to continue
			echo -e "\n$(_msg CONTINUE_REPOSITORY_CLONING)"
			select option in "$(_msg ACEPT)" "$(_msg CANCEL)"; do
				case $option in
					"$(_msg ACEPT)")
						echo "$(_msg CLONING_REPOSITORY)"
						git clone $REPO_URL
						cd "$THIRDPARTY_DIR"
						
						# List the available branches in the repository
						echo -e "\n$(_msg LISTING_AVAILABLE_BRANCHE)"
						git fetch --all
						branches=$(git branch -r | grep -v '\->' | sed 's/origin\///' )
						
						# Display the branches to the user with option to exit
						echo -e "$(_msg SELECT_BRANCH_OR_EXIT)"
						select branch in $branches "$(_msg EXIT)"; do
							if [[ "$branch" == "$(_msg EXIT)" ]]; then
								echo "$(_msg EXITING_CLONING_PROCESS)"
								exit 1
							elif [[ -n "$branch" ]]; then
								echo "$(_msg SELECTED_BRANCH)"
								git checkout "$branch"
								break
							else
								echo "$(_msg INVALID_SELECTION_TRY_AGAIN)"
							fi
						done
						break
						;;
					"$(_msg CANCEL)")
						echo "$(_msg EXIT_INSTALL)"
						exit 1
						;;
					*)
						echo "$(_msg INVALID_OPTION_TRY_AGAIN)"
						;;
				esac
			done
		fi
}

_001_install () {

		if [ ! -e "$CHECKFILE_PACKAGES" ]; then 

			sudo add-apt-repository --yes ppa:beineri/opt-qt-5.15.2-focal
			sudo apt-get update
			sudo apt-get install build-essential git make
			sudo apt-get install -y python2 cmake liblzo2-dev liblz4-dev libfreetype6-dev libpng-dev libegl1-mesa-dev libgles2-mesa-dev libglew-dev freeglut3-dev qt515script libsuperlu-dev qt515svg qt515tools qt515multimedia wget libboost-all-dev liblzma-dev libjson-c-dev libjpeg-turbo8-dev libturbojpeg0-dev libglib2.0-dev qt515serialport
			sudo apt-get install -y nasm yasm libgnutls28-dev libunistring-dev libass-dev libbluray-dev libmp3lame-dev libopus-dev libsnappy-dev libtheora-dev libvorbis-dev libvpx-dev libwebp-dev libxml2-dev libfontconfig1-dev libfreetype6-dev libopencore-amrnb-dev libopencore-amrwb-dev libspeex-dev libsoxr-dev libopenjp2-7-dev
			sudo apt-get install -y python3-pip
			sudo apt-get install -y build-essential libgirepository1.0-dev autotools-dev intltool gettext libtool patchelf autopoint libusb-1.0-0 libusb-1.0-0-dev
			sudo apt-get install -y libdeflate-dev

			pip3 install --upgrade pip
			pip3 install numpy

			# Leave repo directory for this step
			cd ..

			# Remove this as the version that is there is old and causes issues compiling opencv
			sudo apt-get remove libprotobuf-dev

			# Need protoc3 for some compiles.  don't use the apt-get version as it's too old.

			if [ ! -d protoc3 ]; then
			wget https://github.com/google/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip
			# Unzip
			unzip protoc-3.6.1-linux-x86_64.zip -d protoc3
			fi

			# Move protoc to /usr/local/bin/
			sudo cp -pr protoc3/bin/* /usr/local/bin/

			# Move protoc3/include to /usr/local/include/
			sudo cp -pr protoc3/include/* /usr/local/include/

			sudo ldconfig

		fi

	touch "$CHECKFILE_PACKAGES"

}

_002_ffmpeg() {

		if [ ! -e "$CHECKFILE_FFMPEG" ]; then

			cd "$THIRDPARTY_DIR"

			echo ">>> Cloning openH264"
			git clone https://github.com/cisco/openh264.git openh264

			cd openh264
			echo "*" >| .gitignore

			echo ">>> Making openh264"
			make

			echo ">>> Installing openh264"
			sudo make install

			cd ..

			echo ">>> Cloning ffmpeg"
			git clone -b v4.3.1 https://github.com/charliemartinez/FFmpeg ffmpeg

			cd ffmpeg
			echo "*" >| .gitignore

			echo ">>> Configuring to build ffmpeg (shared)"
			export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

			./configure  --prefix=/usr/local \
					--cc="$CC" \
					--cxx="$CXX" \
					--toolchain=hardened \
					--pkg-config-flags="--static" \
					--extra-cflags="-I/usr/local/include" \
					--extra-ldflags="-L/usr/local/lib" \
					--enable-pthreads \
					--enable-version3 \
					--enable-avresample \
					--enable-gnutls \
					--enable-libbluray \
					--enable-libmp3lame \
					--enable-libopus \
					--enable-libsnappy \
					--enable-libtheora \
					--enable-libvorbis \
					--enable-libvpx \
					--enable-libwebp \
					--enable-libxml2 \
					--enable-lzma \
					--enable-libfreetype \
					--enable-libass \
					--enable-libopencore-amrnb \
					--enable-libopencore-amrwb \
					--enable-libopenjpeg \
					--enable-libspeex \
					--enable-libsoxr \
					--enable-libopenh264 \
					--enable-shared \
					--disable-static \
					--disable-libjack \
					--disable-indev=jack

			echo ">>> Building ffmpeg (shared)"
			make

			echo ">>> Installing ffmpeg (shared)"
			sudo make install

			sudo ldconfig
		fi

	touch "$CHECKFILE_FFMPEG"

}

_003_opencv() {

		if [ ! -e "$CHECKFILE_MPAINT" ]; then
			cd "$THIRDPARTY_DIR"

			echo ">>> Cloning opencv"
			git clone https://github.com/charliemartinez/opencv

			cd opencv
			echo "*" >| .gitignore

				if [ ! -d build ]; then
					mkdir build
				fi
			cd build

			echo ">>> Cmaking openv"
			cmake -DCMAKE_BUILD_TYPE=Release \
					-DBUILD_JASPER=OFF \
					-DBUILD_JPEG=OFF \
					-DBUILD_OPENEXR=OFF \
					-DBUILD_PERF_TESTS=OFF \
					-DBUILD_PNG=OFF \
					-DBUILD_PROTOBUF=OFF \
					-DBUILD_TESTS=OFF \
					-DBUILD_TIFF=OFF \
					-DBUILD_WEBP=OFF \
					-DBUILD_ZLIB=OFF \
					-DBUILD_opencv_hdf=OFF \
					-DBUILD_opencv_java=OFF \
					-DBUILD_opencv_text=ON \
					-DOPENCV_ENABLE_NONFREE=ON \
					-DOPENCV_GENERATE_PKGCONFIG=ON \
					-DPROTOBUF_UPDATE_FILES=ON \
					-DWITH_1394=OFF \
					-DWITH_CUDA=OFF \
					-DWITH_EIGEN=ON \
					-DWITH_FFMPEG=ON \
					-DWITH_GPHOTO2=OFF \
					-DWITH_GSTREAMER=ON \
					-DWITH_JASPER=OFF \
					-DWITH_OPENEXR=ON \
					-DWITH_OPENGL=OFF \
					-DWITH_QT=OFF \
					-DWITH_TBB=ON \
					-DWITH_VTK=ON \
					-DBUILD_opencv_python2=OFF \
					-DBUILD_opencv_python3=ON \
					-DCMAKE_INSTALL_NAME_DIR=/usr/local/lib \
					..

			echo ">>> Building opencv"
			make

			echo ">>> Installing opencv"
			sudo make install
		fi

	touch "$CHECKFILE_MPAINT"

}

_004_mypaint() {

		if [ ! -e "$CHECKFILE_MPAINT" ]; then
			cd $THIRDPARTY_DIR/libmypaint

			echo ">>> Cloning libmypaint"
			git clone https://github.com/charliemartinez/libmypaint src

			cd src
			echo "*" >| .gitignore

			export CFLAGS='-Ofast -ftree-vectorize -fopt-info-vec-optimized -march=native -mtune=native -funsafe-math-optimizations -funsafe-loop-optimizations'

			echo ">>> Generating libmypaint environment"
			./autogen.sh

			echo ">>> Configuring libmypaint build"
			sudo ./configure

			echo ">>> Building libmypaint"
			sudo make

			echo ">>> Installing libmypaint"
			sudo make install

			sudo ldconfig

		fi

	touch "CHECK_MYPAINT"

}

_005_gphoto() {

		if [ ! -e "$CHECKFILE_GPHOTO" ]; then

			cd "$THIRDPARTY_DIR"

			echo ">>> Cloning libgphoto2"
			git clone https://github.com/charliemartinez/libgphoto2.git libgphoto2_src

			cd libgphoto2_src

			git checkout tahoma2d-version

			echo ">>> Configuring libgphoto2"
			autoreconf --install --symlink

			./configure --prefix=/usr/local

			echo ">>> Making libgphoto2"
			make

			echo ">>> Installing libgphoto2"
			sudo make install

			cd ..

		fi

	touch "$CHECKFILE_GPHOTO"

}

_006_build(){

	pushd $THIRDPARTY_DIR/tiff-4.2.0
	CFLAGS="-fPIC" CXXFLAGS="-fPIC" ./configure --disable-jbig --disable-webp && make
	popd

	cd toonz

		if [ ! -d build ]; then
			mkdir build
		fi
		cd build

	source /opt/qt515/bin/qt515-env.sh

		if [ -d "$THIRDPARTY_DIR/canon/Header" ]; then
			export CANON_FLAG=-DWITH_CANON=ON
		fi

	export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
	cmake ../sources  $CANON_FLAG \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DWITH_GPHOTO2:BOOL=ON \
		-DWITH_SYSTEM_SUPERLU=ON

	make -j7

}

_007_apps(){

	cd "$THIRDPARTY_DIR"

		if [ ! -d apps ]; then
			mkdir apps
		fi
	cd apps
	echo "*" >| .gitignore

	echo ">>> Getting FFmpeg"
		if [ -d ffmpeg ]; then
			rm -rf ffmpeg
		fi
	wget https://github.com/charliemartinez/FFmpeg/releases/download/v5.0.0/ffmpeg-5.0.0-linux64-static-lgpl.zip
	unzip ffmpeg-5.0.0-linux64-static-lgpl.zip 
	mv ffmpeg-5.0.0-linux64-static-lgpl ffmpeg


	echo ">>> Getting Rhubarb Lip Sync"
		if [ -d rhubarb ]; then
			rm -rf rhubarb ]
		fi
		wget https://github.com/charliemartinez/rhubarb-lip-sync/releases/download/v1.13.0/rhubarb-lip-sync-tahoma2d-linux.zip
		unzip rhubarb-lip-sync-tahoma2d-linux.zip -d rhubarb

}

_008_dpkg() {

	source /opt/qt515/bin/qt515-env.sh

	echo ">>> Temporary install of Tahoma2D"
	SCRIPTPATH=`dirname "$0"`
	export BUILDDIR=$SCRIPTPATH/../../toonz/build
	cd $BUILDDIR
	sudo make install

	sudo ldconfig

	echo ">>> Creating appDir"
		if [ -d appdir ]; then
			rm -rf appdir
		fi
	mkdir -p appdir/usr

	echo ">>> Copy and configure Tahoma2D installation in appDir"
	cp -r /opt/tahoma2d/* appdir/usr
	cp appdir/usr/share/applications/*.desktop appdir
	cp appdir/usr/share/icons/hicolor/*/apps/*.png appdir
	mv appdir/usr/lib/tahoma2d/* appdir/usr/lib
	rmdir appdir/usr/lib/tahoma2d

	echo ">>> Creating Tahoma2D directory"
		if [ -d Tahoma2D ]; then
			rm -rf Tahoma2D
		fi
	mkdir Tahoma2D

	echo ">>> Copying stuff to Tahoma2D/tahomastuff"

	mv appdir/usr/share/tahoma2d/stuff Tahoma2D/tahomastuff
	chmod -R 777 Tahoma2D/tahomastuff
	rmdir appdir/usr/share/tahoma2d

	find Tahoma2D/tahomastuff -name .gitkeep -exec rm -f {} \;

		if [ -d "$THIRDPARTY_DIR/apps/ffmpeg/bin" ]; then
			echo ">>> Copying FFmpeg to Tahoma2D/ffmpeg"
			if [ -d Tahoma2D/ffmpeg ]; then
				rm -rf Tahoma2D/ffmpeg
			fi
			mkdir -p Tahoma2D/ffmpeg
			cp -R $THIRDPARTY_DIR/apps/ffmpeg/bin/ffmpeg $THIRDPARTY_DIR/apps/ffmpeg/bin/ffprobe Tahoma2D/ffmpeg
			chmod -R 755 Tahoma2D/ffmpeg
		fi

		if [ -d "$THIRDPARTY_DIR/apps/rhubarb" ]; then
			echo ">>> Copying Rhubarb Lip Sync to Tahoma2D/rhubarb"
			if [ -d Tahoma2D/rhubarb ]; then
			  rm -rf Tahoma2D/rhubarb
			fi
			mkdir -p Tahoma2D/rhubarb
			cp -R $THIRDPARTY_DIR/apps/rhubarb/rhubarb $THIRDPARTY_DIR/apps/rhubarb/res Tahoma2D/rhubarb
			chmod 755 -R Tahoma2D/rhubarb
		fi

		if [ -d "$THIRDPARTY_DIR/canon/Library" ]; then
			echo ">>> Copying canon libraries"
			cp -R $THIRDPARTY_DIR/canon/Library/x86_64/* appdir/usr/lib
		fi

	echo ">>> Copying libghoto2 supporting directories"
	cp -r /usr/local/lib/libgphoto2 appdir/usr/lib
	cp -r /usr/local/lib/libgphoto2_port appdir/usr/lib

	rm appdir/usr/lib/libgphoto2/print-camera-list
	find appdir/usr/lib/libgphoto2* -name *.la -exec rm -f {} \;
	find appdir/usr/lib/libgphoto2* -name *.so -exec patchelf --set-rpath '$ORIGIN/../..' {} \;

	echo ">>> Creating Tahoma2D/Tahoma2D.AppImage"

		if [ ! -f linuxdeployqt*.AppImage ]; then
			wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
			chmod a+x linuxdeployqt*.AppImage
		fi

	export LD_LIBRARY_PATH=appdir/usr/lib/tahoma2d
	./linuxdeployqt*.AppImage appdir/usr/bin/Tahoma2D -bundle-non-qt-libs -verbose=0 -always-overwrite -no-strip \
		-executable=appdir/usr/bin/lzocompress \
		-executable=appdir/usr/bin/lzodecompress \
		-executable=appdir/usr/bin/tcleanup \
		-executable=appdir/usr/bin/tcomposer \
		-executable=appdir/usr/bin/tconverter \
		-executable=appdir/usr/bin/tfarmcontroller \
		-executable=appdir/usr/bin/tfarmserver 

	rm appdir/AppRun
	cp ../sources/scripts/AppRun appdir
	chmod 775 appdir/AppRun

	./linuxdeployqt*.AppImage appdir/usr/bin/Tahoma2D -appimage -no-strip 

	mv Tahoma2D*.AppImage Tahoma2D/Tahoma2D.AppImage

	echo ">>> Creating Tahoma2D Linux package"

	tar zcf Tahoma2D-linux.tar.gz Tahoma2D

}

# ======================================================================
# Main
# ======================================================================

function _main() {

	_000_var
	_cloneIf
	_001_install
	_002_ffmpeg
	_003_opencv
	_004_mypaint
	_005_gphoto
	_006_build
	_007_apps
	_008_dpkg

}
_main
