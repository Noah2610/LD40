
class Group
	attr_reader :leader, :group_id
	def initialize args
		@group_id = $group_ids
		$group_ids += 1
		@leader = nil
		@base = nil
		if (!args[:people].nil? && args[:people].class == Array)
			add_people args[:people]
		end
	end

	def base
		return nil  unless (has_base?)
		return @base
	end

	def remove_base
		@base = nil
	end

	def has_base?
		return !!@base
	end

	def add_base base
		@base = base
	end

	def get_people
		ret = []
		$game.people.each do |person|
			if (person.group_id == @group_id)
				ret << person
			end
		end
		return ret
	end

	def leader
		return @leader
	end

	def has_person? person
		return (person.group_id == @group_id)
	end

	def add_person person
		@leader = person  if (@leader.nil?)
		person.group_id = @group_id
	end

	def add_people people
		people.each do |person|
			add_person person
		end
	end

end

