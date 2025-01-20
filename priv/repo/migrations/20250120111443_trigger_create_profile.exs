defmodule BlindfoldChess.Repo.Migrations.TriggerCreateProfile do
  use Ecto.Migration

  def change do
    execute """
    CREATE OR REPLACE FUNCTION handle_new_user() RETURNS TRIGGER AS $$
    BEGIN
      INSERT INTO profiles (id, user_id, inserted_at, updated_at)
      VALUES (gen_random_uuid(), NEW.id, NEW.inserted_at, NEW.updated_at);
      RETURN NEW;
    END
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER on_user_created
      AFTER INSERT ON users
      FOR EACH ROW EXECUTE PROCEDURE handle_new_user();
    """
  end
end
