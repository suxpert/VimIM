TODO LIST
=========

I am VimIM user for years (the elder one),
and found that it has some issues in different places.
Starting from 2012, I tried to 'fix' those issues,
but since the code is somewhat a little confusing,
I can only fix few of them.

Also, it seems that MXJ et al. were not working on it for a long time,
I was almost the only one who is still patching it.
(But I do not have the permission to change the code in the repo.
So patches are givin as attachments.)

As I have pointed in the discuss, the *best* way to deal with vim and IME
is to take the advantages of an exists IME **WITHOUT** its UI,
but to use a vim build-in UI,
(because VimIM engine itself is not good enough for PinYin users)
so I think VimIM should try to communicate with the system IME.
After @依云 metioned several times of his `fcitx.vim`,
and several reasons on why not use VimIM, which I do not agree,
I think the best way is to make VimIM **much better** than `fcitx.vim`
(Of course it should.)

Thus I decide to rewrite such a plugin,
here are what I think this VimIM **should** be:


