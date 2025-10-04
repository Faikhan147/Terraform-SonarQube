echo "🔍 Initializing Terraform..."
terraform init -reconfigure

echo "✅ Validating configuration..."
terraform validate

echo "📝 Formatting Terraform files..."
terraform fmt -recursive

echo "📄 Creating plan for sonarqube..."
terraform plan -var-file="terraform.tfvars" -out=tfplan.out

echo "⚠️ Review the plan output before applying:"
terraform show tfplan.out

# Fixed the read command syntax
echo "🚀 Do you want to apply this plan to launch sonarqube? (yes/no)"
read choice

if [ "$choice" == "yes" ]; then
    echo "✅ Applying changes to launch sonarqube..."
    terraform apply "tfplan.out"
    
    echo "📊 Showing the current state after applying the plan..."
    terraform show
else
    echo "❌ Deployment cancelled."
fi
