# Windpower Books

Record book for a Windpower tire distributor: notas, goods received from Jakarta, unpaid notas, stock, prices, photos and simple reports (profit, money in and out, what the business owns and owes).

It is one web page (`index.html`). Records are saved in **Supabase**, a free online database. Everyone who uses the book signs in with their own email.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `config.js` | The address and key of your Supabase database (you fill this in) |
| `supabase/setup.sql` | Creates the tables, access rules, photo storage and the two Windpower tires |

## Setup (about 15 minutes, once)

### 1. Create the database
1. Go to supabase.com, sign up, and click **New project**. Pick the region **Southeast Asia (Singapore)**. Save the database password somewhere safe.
2. Wait about 2 minutes until the project is ready.

### 2. Create the tables
1. Open `supabase/setup.sql`. On the **last line**, change `owner@example.com` and `Ci Via` to the owner's real email and name.
2. In Supabase, go to **SQL Editor**, click **New query**, paste the whole file and press **Run**. It should say "Success".

### 3. Connect the site to the database
1. In Supabase, go to **Project Settings**, then **API**.
2. Copy the **Project URL** and the **anon public** key into `config.js`.
   - The anon key is safe to put in the site. **Never** put the `service_role` key anywhere in this repo.

### 4. Tell Supabase where the site lives
After the site is online (step 5), go to **Authentication**, then **URL Configuration**, and set **Site URL** to the site's address (for example `https://windpower-books.vercel.app`). Without this, confirm and reset-password emails link to the wrong place.

### 5. Put the site online
Either one works, since it's a plain static site:
- **Vercel:** Add New Project, import this repo, keep every setting as it is, then Deploy.
- **GitHub Pages:** repo Settings, then Pages, set Source to `main` branch and `/ (root)`.

### 6. First sign-in
1. The owner opens the site, chooses **Create account** with the email from step 2, sets a password, and confirms the email.
2. Signing in then shows the empty book. Start with **Record, Opening balances**.

## Giving access to staff (for example Ci Bella)
1. The owner opens **Setup**, then **Who can use this book**, types the person's email and name, and presses **Give access**.
2. That person opens the site, chooses **Create account** with the same email, and confirms it from their inbox.

Anyone who signs up without being on that list sees "Waiting for access" and cannot see any records.

## Good to know
- **Backups:** **Journal, Download as CSV** saves every entry. The free Supabase plan also pauses a project after 7 days with no use. Opening the site wakes it up, but if nobody uses it for a week it can take a minute to start.
- **Photos** are stored in Supabase Storage (bucket `tire-photos`). The photo links are public but impossible to guess.
- **"Look around with example data"** on the sign-in page shows a full demo without saving anything. Useful when presenting to the client.
