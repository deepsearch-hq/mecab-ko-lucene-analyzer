#!/bin/bash -e

version=$(grep -m 1 "<version>.*</version>" pom.xml | sed -n 's/.*>\(.*\)-SNAPSHOT.*/\1/p')
elasticsearch_plugin_version=$(grep -m 1 "<version>.*</version>" elasticsearch-analysis-mecab-ko/pom.xml | sed -n 's/.*>\(.*\)-SNAPSHOT.*/\1/p')
lucene_analyzer=mecab-ko-lucene-analyzer
mecab_loader=mecab-ko-mecab-loader
elasticsearch_analysis=elasticsearch-analysis-mecab-ko

# make Lucene/Solr package
dir=mecab-ko-lucene-analyzer-$version
# if [[ -d $dir ]]; then
# 	rm -rf $dir
# fi
mkdir -p $dir
cp lucene-analyzer/target/$lucene_analyzer-$version-SNAPSHOT.jar $dir/$lucene_analyzer-$version.jar
cp mecab-loader/target/$mecab_loader-$version-SNAPSHOT.jar $dir/$mecab_loader-$version.jar
tar czf $dir.tar.gz $dir
rm -rf $dir

# make ElasticSearch plugin
dir=$elasticsearch_analysis-$version
# if [[ -d $dir ]]; then
# 	rm -rf $dir
# fi
mkdir -p $dir
cp lucene-analyzer/target/$lucene_analyzer-$version-SNAPSHOT.jar $dir/$lucene_analyzer-$version.jar
cp mecab-loader/target/$mecab_loader-$version-SNAPSHOT.jar $dir/$mecab_loader-$version.jar
cp elasticsearch-analysis-mecab-ko/target/$elasticsearch_analysis-$elasticsearch_plugin_version-SNAPSHOT.jar $dir/$elasticsearch_analysis-$elasticsearch_plugin_version.jar
cp elasticsearch-analysis-mecab-ko/plugin-descriptor.properties $dir/plugin-descriptor.properties
cp elasticsearch-analysis-mecab-ko/plugin-security.policy $dir/plugin-security.policy
pushd $dir
wget https://bitbucket.org/eunjeon/mecab-java/downloads/mecab-java-0.996.jar
popd
zip -r $elasticsearch_analysis-$elasticsearch_plugin_version.zip $dir
rm -rf $dir
