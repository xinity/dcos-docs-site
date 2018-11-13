# Links and Images

find ./pages/zh -type f -exec sed -i '' -e 's/](\/1.11/](\/zh\/1.11/g' {} \;
find ./pages/zh -type f -exec sed -i '' -e 's/](1.11/](zh\/1.11/g' {} \;

# Include files

find ./pages/zh -type f -exec sed -i '' -e 's/#include \/cn/#include \/zh/g' {} \;

# bad code blocks

# Opening
find ./pages/zh -type f -exec sed -i '' -e 's/<```>/```/g' {} \;
# Closing
find ./pages/zh -type f -exec sed -i '' -e 's/<\/```>/```/g' {} \;
# linebreaks
find ./pages/zh -type f -exec sed -i '' -e 's/<linebreak>/\'$'\n/g' {} \;

# Data yml

