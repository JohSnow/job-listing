# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Hello World!'
puts '这个种子会自动建立一个账号, 并且随机创建 10 个公开jobs，10个隐藏的jobs'

create_account = User.create([email: 'admin@gmail.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
puts 'Admin account is created successfully!'

job_info = [
  '招聘RoR工程师',
  '招聘文案设计',
  '招聘UI设计师',
  '招聘Android开发工程师',
  '招聘产品经理',
  '招聘前端开发工程师',
  '招聘市场营销',
  '招聘php后台研发工程师',
  '招聘python工程师',
  '招聘高级JAVA研发工程师',
  '招聘高级数据挖掘工程师',
  '招聘高级客服经理'
]
create_jobs = for i in 1..10 do
                Job.create!([title: job_info[rand(job_info.length)], description: "这是一个公开的工作", wage_upper_bound: rand(40..79) * 1000, wage_lower_bound: rand(20..39) * 1000, is_hidden: 'false'])
              end
for i in 1..10 do
  Job.create!([title: job_info[rand(job_info.length)], description: "这是一个隐藏的工作", wage_upper_bound: rand(40..79) * 1000, wage_lower_bound: rand(20..39) * 1000, is_hidden: 'true'])
end

puts '10 Public jobs created.'
puts '10 Hidden jobs created.'
