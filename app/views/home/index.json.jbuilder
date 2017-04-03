json.array!(@data) do |row|
  json.prId        row[:pr_number]
  json.title       row[:title]
  json.author      row[:user]
  json.merged      row[:merged_at].present?
  json.authorLogo  row[:logo]
end
