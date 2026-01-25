# Activeate mise
if command -v mise &> /dev/null; then
		echo "Activating mise..."
		mise install -y
		echo "mise activated successfully!"
else
		echo "mise command not found. Please ensure mise is installed."
fi
