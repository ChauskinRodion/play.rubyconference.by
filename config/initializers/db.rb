require 'csv'
DATABASE = Dir['db/*.csv'].flat_map{|x| CSV.read(x)}.map do |x|
  {
    git_user: x[0],
    repo: x[1],
    pr_number: x[2],
    title: x[3],
    closed_at: x[4],
    merged_at: x[5],
    user: x[6],
    id: x[7],
    logo: x[8]
  }
end
