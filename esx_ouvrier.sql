USE `essentialmode`;

INSERT INTO `jobs` (name, label) VALUES
	('Ouvrier', 'Ouvrier')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('Ouvrier',0,'Ouvrier','Ouvrier',100,'{"tshirt_2":1,"ears_1":8,"glasses_1":15,"torso_2":0,"ears_2":2,"glasses_2":3,"shoes_2":1,"pants_1":75,"shoes_1":51,"bags_1":0,"helmet_2":0,"pants_2":7,"torso_1":71,"tshirt_1":59,"arms":2,"bags_2":0,"helmet_1":0}','{"tshirt_2":1,"ears_1":8,"glasses_1":15,"torso_2":0,"ears_2":2,"glasses_2":3,"shoes_2":1,"pants_1":75,"shoes_1":51,"bags_1":0,"helmet_2":0,"pants_2":7,"torso_1":71,"tshirt_1":59,"arms":2,"bags_2":0,"helmet_1":0}'),
;

INSERT INTO `items` (name, label, `limit`) VALUES
	('scraps', 'Férailles', 20),
	('palette', 'Palette', 20),
	('ciment', 'Ciment', 20)

;
