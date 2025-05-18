echo "🛠️ Initializing Terraform..."
terraform init -reconfigure

echo "📝 Formatting Terraform files..."
terraform fmt -recursive

echo "🛑 WARNING: This will destroy the sonarqube!"
read -p "Are you absolutely sure? Type 'destroy' to continue: " confirm

if [ "$confirm" == "destroy" ]; then
    echo "🔥 Destroying sonarqube infrastructure..."
    terraform destroy -var-file="terraform.tfvars"

    echo "📊 Showing the current state after destroy..."
    terraform show
else
    echo "❌ Destroy aborted."
fi
