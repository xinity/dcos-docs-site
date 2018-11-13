# Links and Images

find ./pages/zh -type f -exec sed -i '' -e 's/](\/1.11/](\/zh\/1.11/g' {} \;
find ./pages/zh -type f -exec sed -i '' -e 's/](1.11/](zh\/1.11/g' {} \;

# Include files

find ./pages/zh -type f -exec sed -i '' -e 's/#include \/cn/#include \/zh/g' {} \;

# Data yml

