# Kaydee

## What Is It?

Kaydee is a PvP tracker addon for World of Warcraft, and is compatible with World of Warcraft: Classic.  

Kaydee watches for any PvP killing blows in your vacinity and records them.  While killing blows are not the most full or accurate way to sum up an entire PvP encounter, they get us 80% of the way there for 5% of the work.  The records tracked are not just Horde vs. Alliance, but all PvP, including Gurubashi Arena and duels.

Kaydee is _not_ an addon for only _your_ data, though.  Kaydee will also automatically share your data with your friends and guildmates, and theirs with you.  This allows you to, for example, see if someone has been killing your friend a lot, and get justice in their stead.

## Enhanced Player Tooltips

The main feature of Kaydee is adding your and your friends' K/D information to player tooltips, as demonstrated here:

![Kaydee Tooltip](https://i.ibb.co/YR2kbRV/Kaydee-Tooltip.png)

This tooltip is saying that "Whatisthis" has defeated "Idonteven" 4 times and lost 0 times.  Your own stats are always shown on top (provided that you have a record with the character you're tooltipping over).  Below Whatisthis' entry is Deadboy's (who is a friend of Whatisthis).

The tooltip will display up to 20 K/D records.  It always shows yours (if applicable), and then shows the data for the 19-20 friends and guildmates of yours who have had the most recorded encounters with the target.

## "Your History"

Clicking on the Kaydee minimap icon or running the `/kaydee history` command will show the "Your History" window:

![Kaydee English UI](https://i.ibb.co/SJvvQVC/Kaydee-English.png)

This window is a log of all of the PvP killing blows you have ever dealt or received (while Kaydee has been enabled).  You can scroll through it and reminsce to your heart's content.

## Warning: Performance

I have noticed that the addon causes subtantial pauses when there are thousands of entries or more.  I intend to solve this in the future by

  1. Allowing the user to toggle Kaydee's logging off (e.g. in preparation for engaging in a 14-hour session of Rank 14 honor grinding)
  2. Aloowing the user to configure a time period for deleting and ignoring old records (e.g. "no longer store records about PvP encounters from over a month ago")
  3. Allowing the user to disable syncing with friends, guildmates, or both
  
I expect that these things will help a lot with keeping the database size manageable.  For now, it should be fine, though (and long as you and your friends aren't the sort to spend your time camping lowbies in Redridge all day).  Check back in October 2019 for an update to address this problem.

If it's causing you problems sooner than expected, you can turn syncing off with `/kaydee sync disable` and then getting rid of your current database by deleting `...\World of Warcraft\<VERSION>\WTF\Account\<ACCOUNT_NUMBER>\SavedVariables\Kaydee.lua`.

## Command Line API

Kaydee supports the following slash commands:

  * `/kaydee help`: Print the available slash commands
  * `/kaydee history`: Show the "Your History" window
  * `/kaydee sync`: Force a sync to your friends and guildmates
  * `/kaydee sync disable`: Configure Kaydee to disable automatically sending syncs and receiving syncs
  * `/kaydee sync enable`: Configure Kaydee to re-enable automatically sending syncs and receiving syncs

## Localization

The addon is available in:

  * English
  * German
  * Spanish

Corrections to my German and Spanish translations are very welcome.
