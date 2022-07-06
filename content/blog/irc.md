+++
title = "I R SSI"
author = ["Prashant Tak"]
date = 2022-06-28T00:00:00+05:30
lastmod = 2022-07-06T06:20:21+05:30
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

{{< figure src="https://imgs.xkcd.com/comics/team_chat.png" link="https://xkcd.com/1782" >}}

Umm. Guilty, though I've only been using it for two days, but I've been having a blast! So let's get into it.

<div class="note">

This is intended for users who are familiar with chat systems like discord and wish to have a similar visual experience while working with IRC. I don't discuss all the aspects such as chat etiquette and other security related stuff for which I'd direct the readers to resources at the bottom.

</div>


## Why IRC? {#why-irc}

In this modern age of numerous chat clients and networks with all their shiny bells and whistles and fancy embeds and numerous intergrations with various services, why should one use IRC?

There's a reason why IRC is called the social network for neckbeards, it's the premier destination of folks who are actually technically-literate about the stuff that they're using and not just flaunting their latest _rice_ or worrying about their choice of distribution. This is not to say that the new platforms don't have adept helpers rather that on IRC channels you can get support for very specific things. Another thing that I recently came across in my journey to various technical channels is that the people there are very willing and understanding when someone seeks help which was in stark contrast to communities on other platforms where people are actively called out for their lack of knowledge, there's a very [prevalant culture](https://blog.aurynn.com/2015/12/16-contempt-culture) of superiority complex in modern technical communities which has been absent in IRC from my limited exposure and experience.

Another big pull towards IRC for me has been the exclusive number of niche communities where it's the sole medium of communication for them, this allows you to get exposed to new factions of people! It's a great way to have conversations in plaintext without having to worry about people knowing who you really are, which is kinda neat and unique in its own way.


## Getting into it {#getting-into-it}

If you've used a modern chat platform like Slack or Discord, IRC's structured in a similar way (rather it was most likely the inspiration for these programs). Basically there are various **servers** that you can connect to, which have multiple **channels** that you can join. Unlike discord though where upon joining a server you automatically have access to all its channels, in IRC servers it's opt-in which makes sense considering some large servers have thousands of chatrooms.

When you open an IRSSI for the first time, you're greeted with a barren window with an unfamiliar layout, don't worry later we'll see how to configure it to make it more convenient to use and similar to a new platform like discord. For now let's connect to our first server.

```sh
/set nick <nick>
/server connect irc.libera.chat
```

After connecting to the server you can then join a channel of choice, but how would one know what all channels are there for a server, well for small servers you could use the `/list` command but for large channels such as `libera` or `rizon` that's not really a good idea. So for discovering channels, one can either [filter](https://libera.chat/guides/findingchannels%20) through the various list options or go to [netsplit](https://netsplit.de/channels/). After choosing a channel for a server you're connected to, you can join it and chat. Also, chat can be scrolled via `fn+arrow` keys.

```sh
/join gentoo
```

But there's a catch, once you close irssi, you'll realize that you'll have to go through the entire process again so to autoconnect to various servers and channels you can either edit your `~/.irssi/config` file or do it right from the client. There's also another annoyance, there are automated messages for whenever people join or leave channels so ignoring these provides for a cleaner chat experience.

```sh
/server add -auto -network Libera irc.libera.chat 6697
/channel add -auto #gentoo Libera
/ignore #gentoo JOINS PARTS QUITS
```

A particular window can be be closed by `/wc`. I always forget the right commands so I created aliases for those in my IRSSI config.

```cfg
ADDSERV = "SERVER ADD -AUTO -NETWORK";
# can be used as /ADDSERV irc.libera.chat 6697
ADD = "CHANNEL ADD -AUTO";
# /ADD #gentoo Libera
IGNCH = "IGNORE $0 JOINS PARTS QUITS";
# /IGNCH #gentoo
```


## Layout/Statusbar {#layout-statusbar}

{{< figure src="/ox-hugo/irssi.png" caption="<span class=\"figure-number\">Figure 1: </span>IRSSI Layout. (Dark mode users click on the image to see the actual colours 😛)" link="/ox-hugo/irssi.png" >}}

There's a statusbar at the bottom which shows the current `nick/server/channel/active_channels`. There's a window on the left which shows all the joined servers and channels (courtesy of  `adv_windowlist`) and a window on the right which has list of all users (via `tmux-nicklist-portable`). To get this style of statusbar and colorscheme, I'm currently using a theme derived from the popular [weed](https://github.com/ronilaukkarinen/weed) theme where I did minor modifications on statusbar and messagelist.


## Scripts {#scripts}

If you've ever used emacs, you'll know how it being an elisp interpreter lends to it powers of on-the-fly changes and extensibility beyond any measure. IRSSI is similar in that manner, it allows for modifications via perl scripts. There's a central [scripts repository](https://scripts.irssi.org/) but one can create their own scripts akin to emacs packages!

<div class="note">

In later iterations of this post, I'll add customization options for mentioned scripts.

</div>

Here I'd like to mention some popular scripts which can easily improve both visual and functional experience while using irssi. These are

1.  `adv_windowlist` which provides a list of all connected servers and channel akin to discord's sidebar
2.  `tmux-nicklist-portable` which adds a userlist for each channel on the right
3.  `mouse` for adding mouse scroll support
4.  `savecmdhist` which allows for a persistant history of commands
5.  `trackbar` adds a visual indicator underneath the message since last channel access
6.  Still not working: desktop-notify : needs, cpan Glib::Object::Introspection for that we do `yay -S perl-glib-object-introspection`


## XDCC {#xdcc}

Some IRC channels also offer a way to share files via XDCC. It works by sending bots PMs with requests for a particular pack number which is a reference to the desired file.

<div class="warning">

⚠ A word of caution, enabling automatic DCC is a very bad idea in general since it runs the risk of exposing your IP if the network doesn't have masking enabled so be wary of accepting files.

</div>

After knowing the pack number and the related bot, one sends the request and to automatically accept requests from that bot once can enable whitelist it by enabling autget for it, if you don't wish to do that for each bot you can enable it globally but that is not advised.

```sh
/MSG <BOT> XDCC SEND <PKNO>
# to whitelist a bot
/set dcc_autoget_masks <BOT>
# alternatively
/dcc get <BOT>
# global autoget
/set dcc_autoget on
# to set download dir
/set dcc_download_path <DIR>
# enable autoresume of files
/set dcc_autoresume on
```


## Limitations {#limitations}

There are some limitations with IRC there's no chat persistance unless you use a bouncer which I still have to dip my feet into, maybe that's something for a future post, we'll see.


## Further Reading {#further-reading}

1.  [The IRC Prelude](https://www.irchelp.org/faq/new2irc.html)
2.  [IRSSI for New Users](https://irssi.org/New-users/)
3.  [IRSSI Setup Options](https://irssi.org/documentation/settings/)
4.  [History of IRC](https://daniel.haxx.se/irchistory.html)
5.  [IRC Cheatsheet](https://gist.github.com/xero/2d6e4b061b4ecbeb9f99)
6.  Direct Client-to-Client Protocol: [DCC](https://modern.ircdocs.horse/dcc.html)
