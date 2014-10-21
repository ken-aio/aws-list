#!/usr/bin/env ruby
 
# -*- coding: utf-8 -*-
 
require 'rubygems'
require 'yaml'
require 'aws-sdk'
 
config = YAML.load(File.read("config.yml"))
AWS.config(config)

s3 = AWS::S3.new(config)

cache = []

puts '!! S3 Bucketリスト'
puts "|| # || Name || 確認者 || 対応方法(削除/そのまま) || 対応状況 ||" 
s3.buckets.each_with_index do |s, n|
  puts "|| #{n + 1} || #{s.name} || (確認者) || (対応方法) || □  ||"
end
