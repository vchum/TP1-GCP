# tp1-gcp
## La structure du projet : 

<img width="215" alt="image" src="https://github.com/vchum/tp1-gcp/assets/25177163/459f97ce-46d9-4648-af12-2a3d43a9eb03">

## Les pré-requis :

 - OS Linux Debian ou Ubuntu
 - Clé ssh
 - gcloud CLI
 - compte GCP
 - projet GCP
 - Terraform
 - Ansible

## GCP Modules obligatoire à activer :

- Computer Engine API

## Procédure pour installer gcloud CLI sur Debian/Ubuntu :

sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates gnupg curl sudo

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update && sudo apt-get install google-cloud-cli


## Comment obtenir une clé de service pour le projet :

Lien vers Google Cloud Console : https://console.cloud.google.com/

### Partie IAM :

#### Dans "Comptes de Service" :

##### Créer un compte de service : 

1) Entrer un nom du compte
2) Attribuer le role : Editeur
3) Cliquer sur créer.

##### Créer la clé de service :

1) Cliquer sur le compte qu'on vient de créer, et sur l'onglet "Clés"
2) Cliquer sur "Ajouter une clé" / Créer une clé
3) Selectionner le type en "json" et cliquer sur créer
4) Sauvegarder la clé dans la racine du projet
5) renommer la clé en : "service_account.json"

## Configuration de gcloud CLI:

### Affectation du projet GCP : 
gcloud config set project <nom_projet>

### Ajouter sa clé rsa public dans GCP :
1) Aller dans le dossier où est situé votre clé rsa public.
2) Executer les commandes suivantes :
   
   - gcloud compute os-login ssh-keys add --key-file=id_rsa.pub
   
   - gcloud compute config-ssh --ssh-key-file=id_rsa

## Le schéma de présentation du déploiement :
<img width="856" alt="Capture d'écran 2023-08-24 111655" src="https://github.com/vchum/tp1-gcp/assets/25177163/8dfcd687-ec4b-47c3-bace-76ffe673e8ef">

