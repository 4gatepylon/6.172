
public interface Verifier {
    public String getBoard();
    public void cleanup();
    public int makeToSan(String mv); // returns number of victims if move is valid else -1
    public void setupPosition(String position);
    public String status(); // Possible return values::
                            // "mate - white wins"
                            // "mate - black wins"
                            // "draw"
                            // "ok"
}
