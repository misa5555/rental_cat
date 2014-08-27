users = ["Alice", "kelly", "misa", "appacademystudent", "bob"].map do |names|
  User.create!(username: names, password: "password")
end

stats = {
  Zoba: {
    color: :black,
    sex: "M",
    description: "A lovable goofball who likes to eat and cuddle."
	},
	Mija: {
		color: :black,
    sex: "F",
		description: "She's a princess, who will claw your face off if you don't pet her."
	},
	Pikey: {
		color: :black,
    sex: "M",
		description: "He is a rebellious lover boy."
	},
	Garfield: {
		color: :tabby,
    sex: "M",
		description: "He's lazy and can eat a lot of lasagna."
	},
	Obama: {
		color: :brown,
    sex: "M",
		description: "He's to blame for the state of affairs."
	},
  TheDoctor: {
		color: :calico,
    sex: "M",
    description: "It's not where is he, but when is he?"
	},
	Cleopatra: {
		color: :white,
    sex: "F",
		description: "Even though she's hairless, she will rule the house with grace."
	},
	MsPiggy: {
		color: :tabby,
    sex: "F",
		description: "She was found in the dumpster behind a taqueria."
	},
}
cats = stats.keys.map do |name|
  age_in_days = rand(365..(18 * 365))
  birth = Date.today - age_in_days
  age = age_in_days / 365

  Cat.create!(
    name: name,
    color: stats[name][:color].to_s,
    birth_date: birth,
    age: age,
    sex: stats[name][:sex],
    description: stats[name][:description],
    user_id: users.sample.id
  )
end

rentals = 45.times do |n|
  start_date = Date.today + rand(1..365)
  end_date = start_date + rand(7..21)

  CatRentalRequest.create!(
    cat_id: cats.sample.id,
    start_date: start_date,
    end_date: end_date,
    user_id: users.sample.id
  )
end
