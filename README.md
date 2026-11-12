# Windpower Books (mockup)

A clickable mockup of a record book for a Windpower tire distributor. It covers notas, goods received from Jakarta, unpaid notas, stock and prices, and simple reports.

**It is a mockup only.** It opens with example data. You can record, edit and delete freely to show how it works, but nothing is saved: reloading the page starts over. There is no database and no sign-in.

## How it works
- **New transaction** (the blue button, or **+ New** on phones): choose what happened, fill in the form, press Save. Everything else updates by itself.
- **Fix a mistake:** open **Transactions**, tap the entry, press **Fix this**, correct it and save. Delete is there too.
- **Financial reports** (under More) are the formal statements for an accountant, in the usual Indonesian layout. Nobody needs them day to day.

## What it shows
- **Sale:** copy a paper nota (nota number, shop, tires, discount, ongkir, paid now or 7, 14 or 30 days credit).
- **Payment received:** tick which notas are paid and pick who received the money (Ci Via, Ci Bella or the bank).
- **Unpaid:** every open nota, sorted into late, due soon and later, plus what is still owed to Jakarta.
- **Goods received:** DO quantity compared with what the warehouse counted.
- **Stock and prices:** change prices one by one or by a percentage, and add tire photos.
- **Reports in plain words:** profit, money in and out, what the business owns and owes, stock value.

The bar at the top of the page has **Reset example data** and **Try an empty book**.

## Put it online
It is a single file (`index.html`), so any static host works:
- **Vercel:** Add New Project, import this repo, Deploy. Nothing to configure.
- **GitHub Pages:** Settings, then Pages, set Source to `main` and `/ (root)`.

## Next step after the client approves
Connect a real database (for example Supabase) so records are saved and each person signs in with their own account.
