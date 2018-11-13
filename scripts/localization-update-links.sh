cd pages/zh
find ./ -type f -exec sed -i '' -e 's/](\/1.11/](\/zh\/1.11/g' {} \;
find ./ -type f -exec sed -i '' -e 's/](1.11/](zh\/1.11/g' {} \;

