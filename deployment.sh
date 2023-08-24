#!/bin/bash
#set -x

echo "Installation WORDPRESS sur GCP"
echo "Entrer une zone (1) ou liste zone (2) ou MAJ liste zone (3):"

#Menu pour entrer une zone valide GCP
select i in zone list update; 
do
  if [ "$i" = "zone" ]; then
    
    echo "Veuillez entrer une zone :"  
    read zone1
    cat zone_list | grep $zone1

    if [ $? -eq 0 ]; then
        TA_ZONE=$zone1
        echo "Zone GCP = $TA_ZONE OK"
        break
    else
        echo "Zone non valide."
    fi    
    
  elif [ "$i" = "list" ]; then
    cat zone_list
    echo "Entrer une zone (1) ou liste zone (2) ou MAJ liste zone (3):"

  elif [ "$i" = "update" ]; then
    if [ -f "/usr/bin/gcloud" ]; then
        gcloud compute zones list > zone_list  
        echo "MAJ effectuée."      
    else
        echo "Veuillez installer gcloud CLI pour mettre à jour la liste."
    fi    
  else
    echo "Choix de 1 à 3 uniquement..."
  fi
done

#Controle de présence du fichier service_account.json
if [ -f "service_account.json" ]; then
    echo "Le fichier service_account.json est présent. L'installation peut commencer."
    TA_PROJECT=$(grep "project_id" service_account.json | grep -oP '": "\K[^"]+')
else
    echo "Le fichier service_account.json n'est présent. Veuillez récupérer le fichier sur GCP."
    echo "Fin de l'installation..."
fi

if [ -f "/usr/bin/terraform" ]; then
    echo "Terraform est présent dans le systeme."
else
    echo "Terraform n'est pas présent. Lancement de l'installation..."

    #Installation de Terraform
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt-get install terraform -y

fi

if [ -f "/usr/bin/ansible" ]; then
    echo "Ansible est présent dans le systeme."
else

    echo "Ansible n'est pas présent. Lancement de l'installation..."

    echo "Vérification de la version de PIP Python 3"
    python3 -m pip -V

    if [ $? -eq 1 ]; then 
        echo "PIP Python 3 n'est pas présent. Lancement de l'installation..."
        #Installation de PIP3
        sudo apt install python3-pip
    fi
    #Installation d'Ansible + google-auth + requests
    python3 -m pip install --user ansible google-auth requests

    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible -y

fi

#Modification des fichiers de configuration Terraform et Ansible avec l'ID du projet GCP
sed "s/{TA_PROJECT}/$TA_PROJECT/g" -i ./terraform/main.tf
if [ $? -eq 1 ]; then
    echo "Modification non effectuée. Arret du script."
    exit
fi

sed "s/{TA_ZONE}/$TA_ZONE/g" -i ./terraform/main.tf
if [ $? -eq 1 ]; then
    echo "Modification non effectuée. Arret du script."
    exit
fi

sed "s/{TA_REGION}/${TA_ZONE%??}/g" -i ./terraform/main.tf
if [ $? -eq 1 ]; then
    echo "Modification non effectuée. Arret du script."
    exit
fi

sed "s/{TA_PROJECT}/$TA_PROJECT/g" -i ./ansible/openlites/gcp_compute.yml
if [ $? -eq 1 ]; then
    echo "Modification non effectuée. Arret du script."
    exit
fi

sed "s/{TA_ZONE}/$TA_ZONE/g" -i ./ansible/openlites/gcp_compute.yml
if [ $? -eq 1 ]; then
    echo "Modification non effectuée. Arret du script."
    exit
fi

echo "Modification des fichiers conf OK."
 
#Controle si Terraform a déja été lancé 

cd terraform

if [ ! -d ".terraform" ]; then
    echo "Le script n'a pas été lancé. Initialisation de terraform."
    terraform init
else
    echo "Le script a déja été lancé."
fi

#Lancement de terraform pour création des VM sur GCP
echo "Lancement de Terraform apply"
terraform apply -auto-approve
echo "Fin de Terraform apply"

WORDPRESS_IP=$(terraform output wordpress_instance_ip | sed 's/"//g')

sleep 5

#Lancement d'ansible pour approvisionner les VM sur GCP
cd ../ansible/openlites
echo "Lancement de Ansible"
ansible-playbook playbook.yml
echo "Fin de Ansible"

#Controle de la connexion à Wordpress
curl http://$WORDPRESS_IP/wp-admin/install.php | grep installation -i

if [ $? -eq 0 ]; then
    echo "Wordpress est opérationnel. Vous pouvez vous connecter sur le lien ci dessous pour la premiere connexion."
    echo "URL : http://$WORDPRESS_IP/wp-admin/install.php" 
else
    echo "Wordpress ne s'est pas correctement installé. Veuillez relancer le script."
fi

cd ../..

#Reinit des fichiers conf
sed "s/$TA_PROJECT/{TA_PROJECT}/g" -i ./terraform/main.tf
sed "s/$TA_ZONE/{TA_ZONE}/g" -i ./terraform/main.tf
sed "s/${TA_ZONE%??}/{TA_REGION}/g" -i ./terraform/main.tf
sed "s/$TA_PROJECT/{TA_PROJECT}/g" -i ./ansible/openlites/gcp_compute.yml
sed "s/$TA_ZONE/{TA_ZONE}/g" -i ./ansible/openlites/gcp_compute.yml
