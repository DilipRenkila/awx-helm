#!/bin/bash
# # Migrate database
# bash -c "awx-manage migrate --noinput"

# # Check for tower super users
# bash -c "echo 'from django.contrib.auth.models import User; nsu = User.objects.filter(is_superuser=True).count(); exit(0 if nsu > 0 else 1)' | awx-manage shell"

# # Create django super user if it does not exist
# if [ $? -ne 0 ]; then
#     bash -c "echo \"from django.contrib.auth.models import User; User.objects.create_superuser('{{ .Values.admin_user }}', 'root@localhost', '{{ .Values.admin_password }}')\" | awx-manage shell"
#     # Update django super user password
#     bash -c "awx-manage update_password --username='{{ .Values.admin_user }}' --password='{{ .Values.admin_password }}'"
# else
#     :
# fi

# # Create default organization
# bash -c "awx-manage create_preload_data"

# Run script until migration is done
while :
do
    export TEST=`./kubectl exec -it {{ .Release.Name }}-0 --container {{ .Release.Name }}-celery -- awx-manage migrate --plan`
    if [[ "$TEST" =~ 'No planned migration operations.' ]]; then
        echo "Migration complete!"
        # Configure ldap if enabled
        CONFIGURE_LDAP={{ .Values.configure_ldap.enabled }}
        if $CONFIGURE_LDAP; then
            # sleep for 15 seconds until preload data finished
            sleep 15
            echo "Configuring LDAP"
            cd /usr/local/ansible
            ansible-playbook deploy.yaml
        fi
        cd /
        ./kubectl scale --replicas=3 statefulset.apps/{{ .Release.Name }}
        INSTALL_HPA={{ .Values.controller.autoscaling.enabled }}
        if $INSTALL_HPA; then
            ./kubectl apply -f /usr/local/scripts/hpa.yaml
        fi
        break
    else
        echo "Migration ongoing..."
    fi
done

# Cleanup
echo "Cleaning up job Role, Rolebinding, ServiceAccount and ConfigMaps..."
./kubectl delete cm/{{ .Release.Name }}-post-install-scripts
./kubectl delete cm/{{ .Release.Name }}-ansible-ldap-config
./kubectl delete sa/job-admin
./kubectl delete rolebinding/job-admin-rolebinding
./kubectl delete role/job-admin-role
echo "Done."
