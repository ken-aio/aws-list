#!/usr/bin/env ruby
 
# -*- coding: utf-8 -*-
 
require 'rubygems'
require 'yaml'
require 'aws-sdk'
 
config = YAML.load(File.read("config.yml"))
AWS.config(config)

ec2 = AWS::EC2.new(config)

cache = []

puts '! EC2インスタンス'
puts "| # | Name | instance_id | instance_type | status | 作成日 | 確認者 | 対応方法(STOP/TERMINATE/そのまま) | 対応状況 |" 
ec2.instances.each_with_index do |i, n|
  puts "| #{n + 1} | #{i.tags.to_h['Name']} | #{i.id} | #{i.instance_type} | #{i.status} | #{i.launch_time} | (確認者) | (対応方法) | □  |"
  cache.push(name: i.tags.to_h['Name'], id: i.id)
end

puts '---------------------------------------------------------'

puts '! EIP'
puts "| # | eip | instance_name | instance_id | 確認者 | 対応方法(STOP/TERMINATE/そのまま) | 対応状況 |"
ec2.elastic_ips.each_with_index do |i, n|
  instance = cache.find { |item| item[:id] == i.instance_id }
  name = instance ? instance[:name] : ''
  puts "| #{n + 1} | #{i.ip_address} | #{name} | #{i.instance_id} | (確認者) | (対応方法) | □  |"
end

puts '---------------------------------------------------------'

puts '! AMI'
puts "| # | AMI Name | AMI ID | 確認者 | 対応方法(STOP/TERMINATE/そのまま) | 対応状況 |"
ec2.images.with_owner(config['ami_owner']).each_with_index do |img, n|
  puts "| #{n + 1} | #{img.name} | #{img.image_id} | (確認者) | (対応方法) | □  |"
end

puts '---------------------------------------------------------'

cache = []

puts '! Volumes'
puts "| # | Volume ID | Size | Snapshot | Created | State | 確認者 | 対応方法(STOP/TERMINATE/そのまま) | 対応状況 |"
ec2.volumes.each_with_index do |v, n|
  puts "| #{n + 1} | #{v.id} | #{v.size}GB | #{v.create_time} | #{v.status} | (確認者) | (対応方法) | □  |"
  cache.push(id: v.id)
end

puts '---------------------------------------------------------'

puts '! Snapshots'
puts "| # | ID | Volume ID | Size | Created | Description | 確認者 | 対応方法(STOP/TERMINATE/そのまま) | 対応状況 |"
ec2.snapshots.with_owner(config['ami_owner']).each_with_index do |s, n|
  v_id = cache.find { |v| v[:id] == s.volume_id } ? s.volume_id : '(Volume存在無し)'
  puts "| #{n + 1} | #{s.id} | #{v_id} | #{s.volume_size}GB | #{s.start_time} | #{s.description} | (確認者) | (対応方法) | □  |"
end
