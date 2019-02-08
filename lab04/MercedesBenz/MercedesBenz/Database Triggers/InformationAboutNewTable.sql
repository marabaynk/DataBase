create trigger InformationAboutNewTable
on database
for create_table
as
begin
	select top 1 *
	from sys.tables
	order by create_date desc
end;

