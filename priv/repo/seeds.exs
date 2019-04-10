# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FakeEconomyBackend.Repo.insert!(%FakeEconomyBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias FakeEconomyBackend.Accounts.User
alias FakeEconomyBackend.Repo

Repo.delete_all(User)

Repo.insert!(%User{first_name: "Test", last_name: "test", email: "test@example.com", password_hash: Bcrypt.add_hash("test")[:password_hash]})
