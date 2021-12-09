/**
 * Copyright (c) 2021 MIT License by 6.172 Staff
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 **/

//import Game;

class Leiserchess {

    /*
      NOTE: this started out as Khet, so some of this could be wrong!
      format of a move:

      piece are transform from one state(location, typ, rotation) to another
      toPiece does NOT indicate the piece at toSq

      toSq = mv & 0xff
      frSq = (mv & 0xff00) >> 8
      fromPiece =  (mv & 0x30000) >> 16
      toPiece  = (mv & 0xc0000) >> 18
      fromRot   = (mv & 0x300000) >> 20
      toRot  = (mv & 0xc00000) >> 22

      mv (32 bits total) =   | unused (8 bits) | toRot (2 bits) | fromRot (2 bits) | \
                              toPiece (2 bits) | fromPiece (2 bits) |\
                              frSq (8 bits) | toSq (8 bits) |

      bd[sq] (6 important bits) = (unused 26 bits) | color (white, black 2 bits) | \
                                   pieceType (2bits) | orientation (2 bits) |

      piece typs
      -----------
      1 = Pawn
      2 = King
    */
    public static int[][] COMPASS_DIRECTIONS = {{-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}};

    boolean pawnsCollide(int ori1, int ori2, int d) {
      if (d < 4) {
          switch(d) {
              case 0:
                return ori1 != NW && ori2 != SE;
              case 2:
                return ori1 != NE && ori2 != SW;
              case 1:
                return !((ori1 == NW && ori2 == SE)
                                        || (ori1 == NE && ori2 == SW));
              case 3:
                return !((ori1 == NW && ori2 == SE)
                                        || (ori1 == SW && ori2 == NE));
          }
      }
      return this.pawnsCollide(ori2, ori1, 7-d);
    }

    void hitPiece (int victim_sq, int center_piece, boolean remove) {
      if (remove) {
        bd[victim_sq] = 0;
      }
      int curr_fil = victim_sq % AS;
      int curr_rnk = ((victim_sq - curr_fil) / AS) - FIRST_RANK;
      int hitCol = curr_fil;
      int hitRow = curr_rnk;

      if (typeOf(center_piece) != PAWN) return;

      for (int d = 0; d < 8; d++) {
        int nextColId = COMPASS_DIRECTIONS[d][0] + hitCol;
        int nextRow = COMPASS_DIRECTIONS[d][1] + hitRow;
        if (nextColId < 0 || nextColId > 7) { continue; }
        if (nextRow < 0 || nextRow > 7) { continue; }

        int nextPiece = bd[square_of(nextColId, nextRow)];
        if (typeOf(nextPiece) == PAWN && pawnsCollide(center_piece&3, nextPiece&3, d)) {
          hitPiece(square_of(nextColId, nextRow), nextPiece, remove);
        }
      }
    }

    void updateBombVictims(int victim_sq, int center_piece) {
      hitPiece(victim_sq, center_piece, true);
    }

    public int bd[];       // board
    public int mvs[];      // history of moves
    public int ctm;        // color to move (really the ply) (0 = white, 1 = black)
    public int mvlist[];   // list of moves possible from a given pos
    public int mvcount;    // index into list
    public long key[];     // position hash key (doesn't hash color to move)
    public int kloc[];     // location of King

    public int blocked[];

    private static String fileLetters = "abcdefghijkl";
    private static String Pces = "-pkPK";
    private static String PTypes = "-pk";
    private static String PRTypes = "-PK-";
    private static String rots = "ruld";
    private static int AS = 16;
    private static int BS = 8;  // must be less than AS
    // private static int BS = 10;  // must be less than AS
    private static int HALF = BS / 2;
    private static int FIRST_RANK = 2;
    private static int LAST_RANK = FIRST_RANK + BS;

    private static int WBIT = 32;
    private static int BBIT = 16;
    private static int WHITE_OR_BLACK_BIT = WBIT | BBIT;
    private static int IBIT = 48;
    private static int PAWN = 4;
    private static int KING = 8;
    private static int nnn = 0;
    private static int EMPTY = 0;
    private static int BLACK = BBIT;
    private static int WHITE = WBIT;
    private static int NN = 0;
    private static int EE = 1;
    private static int SS = 2;
    private static int WW = 3;

    private static int NW = 0;
    private static int NE = 1;
    private static int SE = 2;
    private static int SW = 3;


    private static int BOARD_WIDTH = 8;

    private boolean gameOver = false;
    private boolean whiteWins = true;
    public  String[] notes = new String[12];

    static int[] laser_map = new int[AS*AS];
    static int laser_map_counter = 1;

    // str[0] should correspond to (rank "8", file "a"), that is, the top
    // left square.

    // Don't understand this comment -cel

    private static int change[][] = {
        { 1, 3, 1, 3 },
        { 0, 2, 0, 2 },
        { 3, 1, 3, 1 },
        { 2, 0, 2, 0 }
    };

    // back of Pawn?
    private static int pawnback[][] = {
        { 1, 1, 0, 0 },
        { 0, 1, 1, 0 },
        { 0, 0, 1, 1 },
        { 1, 0, 0, 1 },
    };

    private int bd_index(int r, int f) {
        return (r + FIRST_RANK) * AS + f;
    }

    private void tfk_board_set(int sq, int type, int color, int ori) {
        bd[sq] = color | type | ori;
    }

    private int square_of(int f, int r) {
        return bd_index(BOARD_WIDTH-1 -r, f);
    }

    //converts a square to string notation
    // ---------------------------------
    private String sqString(int sq) {
        String s;
        char sqFile = fileLetters.charAt(sq & 0xF);
        // rank seems to be a number from 0-7, which is in the opposite direction
        // so it looks like we do 9 - "our rank" to get the real rank
        String sqRank = Integer.toString( (BS+2-1) - (sq >> 4) );

        s = "" + sqFile + sqRank;

        return s;
    }

    private int pieceOf(int mv) {
        return (mv >> 26) & 3;
    }

    private int fromSquare(int mv) {
        return (mv >> 16) & 0xff;
    }

    private int intermediateSquare(int mv) {
        return (mv >> 8) & 0xff;
    }

    private int toSquare(int mv) {
        return (mv >> 0) & 0xff;
    }

    private int rotOf(int mv) {
        return (mv >> 24) & 3;
    }

    // return val can be compared directly with == PAWN or == KING
    private int typeOf(int sq) {
        return (bd[sq] & 0xc);
    }

    // check if color of piece is same color as color to move
    private boolean isSameColor(int sq, int ctm) {
        int fctm = ctm & 1;
        // fc is 0b1000000 (ie 32) if white to move, 16 if black to move
        int fc = 0x30 ^ (0x10 << fctm);
        return ((bd[sq] & fc) != 0);
    }

    private boolean containsPiece(int sq){
        return (bd[sq] & WHITE_OR_BLACK_BIT) != 0;
    }

    private int moveOf(int typ, int rot, int from_sq, int int_sq, int to_sq) {
        return ((typ & 3) << 26) |
               ((rot & 3) << 24) |
               ((from_sq & 0xff) << 16) |
               ((int_sq & 0xff) << 8) |
               ((to_sq & 0xff) << 0);
    }

    // parse_fen_board
    // Input:   board representation as a fen string
    //          unpopulated board position struct
    // Output:   index of where board description ends or 0 if parsing error
    //          (populated) board position struct
    private int parse_fen_board() {
        //String fenstring = "ee5nw1/3NW1NW1SE/6se1/1NW1NW4/4se1se1/1NW6/nw1se1se3/1SE5NN W";
        //String fenstring = "ss3nw3/3nw4/2nw1nw3/1nw3SE1SE/nw1nw3SE1/3SE1SE2/4SE3/3SE3NN W";
        // String fenstring = "1sesw2SESW1/8/SE2SWse2sw/8/8/NNNE1NWne1nwnn/8/2nw2NE2 W";
        String fenstring = "1sw3sw1ss/NE2se4/6sw1/1SE2sw3/3NE3ne/NE7/2NE4nw/EE3SW1NW1 W";
        char[] fen = fenstring.toCharArray();

        // Invariant: square (f, r) is last square filled.
        // Fill from last rank to first rank, from first file to last file
        int f = -1;
        int r = BOARD_WIDTH - 1;

        // Current and next characters from input FEN description
        char c, next_c;

        // Invariant: fen[c_count] is next character to be read
        int c_count = 0;

        // Loop also breaks internally if (f, r) == (BOARD_WIDTH-1, 0)
        while ((c = fen[c_count++]) != '\0') {
            int ori;
            int typ;

            switch (c) {
                // ignore whitespace until the end
            case ' ':
            case '\t':
            case '\n':
            case '\r':
                if ((f == BOARD_WIDTH - 1) && (r == 0)) {  // our job is done
                    return c_count;
                }
                break;

                // digits
            case '1':
                if (fen[c_count] == '0') {
                    c_count++;
                    c += 9;
                }
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                while (c > '0') {
                    if (++f >= BOARD_WIDTH) {
                        //fen_error(fen, c_count, "Too many squares in rank.\n");
                        return 0;
                    }
                    //set_ptyp(&p->board[square_of(f, r)], EMPTY);
                    bd[square_of(f,r)] = EMPTY;
                    c--;
                }
                break;

                // pieces
            case 'N':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'N') {  // White King facing North
                    ori = NN;
                    typ = KING;
                    kloc[0] = square_of(f,r);
                } else if (next_c == 'W') {  // White Pawn facing NW
                    ori = NW;
                    typ = PAWN;
                } else if (next_c == 'E') {  // White Pawn facing NE
                    ori = NE;
                    typ = PAWN;
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                tfk_board_set(square_of(f,r), typ, WHITE, ori);
                //set_ptyp(&p->board[square_of(f, r)], typ);
                //set_color(&p->board[square_of(f, r)], WHITE);
                //set_ori(&p->board[square_of(f, r)], ori);
                break;

            case 'n':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'n') {  // Black King facing North
                    ori = NN;
                    typ = KING;
                    kloc[1] = square_of(f,r);
                } else if (next_c == 'w') {  // Black Pawn facing NW
                    ori = NW;
                    typ = PAWN;
                } else if (next_c == 'e') {  // Black Pawn facing NE
                    ori = NE;
                    typ = PAWN;
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                tfk_board_set(square_of(f,r), typ, BLACK, ori);
                //set_ptyp(&p->board[square_of(f, r)], typ);
                //set_color(&p->board[square_of(f, r)], BLACK);
                //set_ori(&p->board[square_of(f, r)], ori);
                break;

            case 'S':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'S') {  // White King facing SOUTH
                    ori = SS;
                    typ = KING;
                    kloc[0] = square_of(f,r);
                } else if (next_c == 'W') {  // White Pawn facing SW
                    ori = SW;
                    typ = PAWN;
                } else if (next_c == 'E') {  // White Pawn facing SE
                    ori = SE;
                    typ = PAWN;
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                tfk_board_set(square_of(f,r), typ, WHITE, ori);
                //set_ptyp(&p->board[square_of(f, r)], typ);
                //set_color(&p->board[square_of(f, r)], WHITE);
                //set_ori(&p->board[square_of(f, r)], ori);
                break;

            case 's':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 's') {  // Black King facing South
                    ori = SS;
                    typ = KING;
                    kloc[1] = square_of(f,r);
                } else if (next_c == 'w') {  // Black Pawn facing SW
                    ori = SW;
                    typ = PAWN;
                } else if (next_c == 'e') {  // Black Pawn facing SE
                    ori = SE;
                    typ = PAWN;
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                tfk_board_set(square_of(f,r), typ, BLACK, ori);
                //set_ptyp(&p->board[square_of(f, r)], typ);
                //set_color(&p->board[square_of(f, r)], BLACK);
                //set_ori(&p->board[square_of(f, r)], ori);
                break;

            case 'E':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'E') {  // White King facing East
                    tfk_board_set(square_of(f,r), KING, WHITE, EE);
                    //set_ptyp(&p->board[square_of(f, r)], KING);
                    //set_color(&p->board[square_of(f, r)], WHITE);
                    //set_ori(&p->board[square_of(f, r)], EE);
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                break;

            case 'W':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'W') {  // White King facing West
                    tfk_board_set(square_of(f,r), KING, WHITE, WW);
                    kloc[0] = square_of(f,r);
                    //set_ptyp(&p->board[square_of(f, r)], KING);
                    // set_color(&p->board[square_of(f, r)], WHITE);
                    //set_ori(&p->board[square_of(f, r)], WW);
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                break;

            case 'e':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'e') {  // Black King facing East
                    //set_ptyp(&p->board[square_of(f, r)], KING);
                    //set_color(&p->board[square_of(f, r)], BLACK);
                    //set_ori(&p->board[square_of(f, r)], EE);
                    tfk_board_set(square_of(f,r), KING, BLACK, EE);
                    kloc[1] = square_of(f,r);
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                break;

            case 'w':
                if (++f >= BOARD_WIDTH) {
                    //fen_error(fen, c_count, "Too many squares in rank");
                    return 0;
                }
                next_c = fen[c_count++];

                if (next_c == 'w') {  // Black King facing West
                    //set_ptyp(&p->board[square_of(f, r)], KING);
                    //set_color(&p->board[square_of(f, r)], BLACK);
                    //set_ori(&p->board[square_of(f, r)], WW);
                    tfk_board_set(square_of(f,r), KING, BLACK, WW);
                    kloc[1] = square_of(f,r);
                } else {
                    //fen_error(fen, c_count+1, "Syntax error");
                    return 0;
                }
                break;

                // end of rank
            case '/':
                if (f == BOARD_WIDTH - 1) {
                    f = -1;
                    if (--r < 0) {
                        //fen_error(fen, c_count, "Too many ranks");
                        return 0;
                    }
                } else {
                    //fen_error(fen, c_count, "Too few squares in rank");
                    return 0;
                }
                break;

            default:
                //fen_error(fen, c_count, "Syntax error");
                return 0;
            }  // end switch
        }  // end while

        if ((f == BOARD_WIDTH - 1) && (r == 0)) {
            return c_count;
        } else {
            //fen_error(fen, c_count, "Too few squares specified");
            return 0;
        }
    }

    private void initBoard() {
        gameOver = false;
        //parse_fen_board();
        for (int i = 0; i < AS * AS; i++)
            bd[i] = 0;

        for (int i = 0; i < FIRST_RANK * AS; i++)
            bd[i] = IBIT;

        for (int i = LAST_RANK * AS; i < AS * AS; i++)
            bd[i] = IBIT;

        for (int r = FIRST_RANK; r < LAST_RANK; r++)
            for (int f = BS; f < AS; f++)
                bd[r * AS + f] = IBIT;
        parse_fen_board();
        //kloc[0] = bd_index(BS-1, BS-1);
        //kloc[1] = bd_index(0, 0);

        ctm = 0;  //White moves first
        //System.out.println(getBoard());
    }

    public Leiserchess()
    {
        key = new long[4096];
        mvs = new int[4096];
        bd = new int[256];
        kloc = new int[2];
        blocked = new int[256];

        mvlist = new int[640];
        mvcount = 0;
        ctm = 0;

        setupPosition("");
    }

    // todo: need to improve this
    private long hashPosition()
    {
        long h = 203998918981981L;
        // no need to hash color to move
        // if ((ctm & 1) == 1) h = 703998918981987L;

        for (int r = 0; r < 256; r++) {
            h = 31 * h + 11 + bd[r];
        }

        return h;
    }

    public void setupPosition(String opn)
    {
        initBoard();
        key[ctm] = hashPosition();
    }

    private boolean isRep()
    {
        long k = key[ctm];
        int  count = 0;

        for (int c = ctm - 4; c >= 0; c -= 2) {
            if (k == key[c]) {
                count++;
                if (count == 2) return true;
            }
        }

        return false;
    }

    public String status() {

        if (gameOver) {
            if (whiteWins) {
                return "mate - white wins";
            } else {
                return "mate - black wins";
            }
        }
        if (isRep()) {
            return "draw";
        }
        return "ok";
    }

    //attempts to make move indicated by algstr
    //returns -1 if move is illegal
    public int makeMove(String algstr)
    {
        String s = null;
        int    legal = -1;
        gen();

        for(int i = 0; i < mvcount; i++) {
            if(alg(mvlist[i]).equals(algstr)) {
                //if move is in list, should be valid
                legal = imake(mvlist[i]);
                key[ctm] = hashPosition();
                mvs[ctm] = mvlist[i];
                s = algstr;
                break;
            }
        }
        return legal;
    }

    public int makeToSan(String mv)
    {
        return makeMove(mv);
    }

    //converts a move to string notation
    public String alg(int mv) {
        String s;
        int f = fromSquare(mv);
        int i = intermediateSquare(mv);
        int t = toSquare(mv);
        String fromString = sqString( f );
        String intString = sqString( i );
        String toString = sqString( t );
        int r = rotOf(mv);

        s = "" + fromString;

        if(f != t){
            s += toString;
        }
        else {
            if ( r == 1 ) {
                s = s + "R";
            } else if (r == 2) {
                s = s + "U";
            } else if (r == 3) {
                s = s + "L";
            } else { // player's null move
                s += fromString;
            }
        }

        return s;
    }

    // very low level make,  does not shoot laser (only swaps piece)
    public void ll_make(int mv) {
        int f = fromSquare(mv);
        int i = intermediateSquare(mv);
        int t = toSquare(mv);
        int r = rotOf(mv);
        int x;

        if (mv == 0) return;   // null move

        x = bd[f];             // from piece

        if (r == 1) { x = (x & ~3) | ((x+1) & 3); }
        if (r == 2) { x = (x & ~3) | ((x+2) & 3); }
        if (r == 3) { x = (x & ~3) | ((x+3) & 3); }

        bd[f] = bd[i];
        bd[i] = bd[t];
        bd[t] = x;


        if ((bd[f] & 12) == 8)  kloc[ 1 & (bd[f] >> 4) ] = f;
        if ((bd[i] & 12) == 8)  kloc[ 1 & (bd[i] >> 4) ] = i;
        if ((bd[t] & 12) == 8)  kloc[ 1 & (bd[t] >> 4) ] = t;


        ctm++;
    }

    // High-level make that zaps, returns the number of victims.
    public int imake(int mv)
    {
        System.out.println("Before move board is:");
        System.out.println(getBoard());
        if (mv == 0) return 0;

        mvs[ctm] = mv;

        //int swapped_sq = ll_make(mv);
        ll_make(mv);

        int victim_sq = 0;
        int victim_count = 0;

        if ((victim_sq = shootLaser()) != 0) {
            victim_count++;
            int victim = bd[victim_sq];
            bd[victim_sq] = 0;      // kills
        System.out.println("Victim count is");
        System.out.println(victim_count);
        System.out.println(victim);
        System.out.println("After move board is:");
        System.out.println(getBoard());
            if ((victim & 12) == 8) {
                gameOver = true;
                System.out.println("GAME OVER?\n");
                whiteWins = (victim & 48) == 16;
            }
            else {
              // remove other victims
              updateBombVictims(victim_sq, victim);
            }

        }

        return victim_count;
    }

    public long perft(int depth)
    {
        // System.out.printf("%s\n", getBoard());
        // System.exit(0);
        int[] board = new int[256];
        int[] Lkloc = new int[2];
        System.arraycopy(bd, 0, board, 0, 256);
        System.arraycopy(kloc, 0, Lkloc, 0, 2);
        return perftHelper(board, Lkloc, depth, 0);
    }

    public long perftHelper(int[] board, int[] somekloc, int depth, int ply)
    {
        long nodec = 0;

        if(depth == 0) return 1;

        gen();

        if (depth == 1) {
            //for(int i = 0; i < mvcount; i++) {
                //System.out.printf("%s\n", alg(mvlist[i]));;
            //}
            return mvcount;
        }

        //local state
        int[] localBoard = new int[256];
        int[] localKloc = new int[2];

        System.arraycopy(board, 0, localBoard, 0, 256);
        System.arraycopy(somekloc, 0, localKloc, 0, 2 );

        int[] localMoves = new int[260];
        int localCtm = ctm;

        //inital list of moves
        System.arraycopy(localBoard, 0, bd, 0, 256);
        System.arraycopy(localKloc, 0, kloc, 0, 2);

        //save locally, others will modify internal game stte
        for(int i = 0; i < mvcount; i++) {
            localMoves[i] = mvlist[i];
        }

        int localMoveCount = mvcount;

        for(int i = 0; i < localMoveCount; i++) {
            int mv = localMoves[i];

            gameOver = false;
            ctm = localCtm;
            System.arraycopy(localBoard, 0, bd, 0, 256);
            System.arraycopy(localKloc, 0, kloc, 0, 2 );

            imake(localMoves[i]);

            long snodec = nodec;

            if (gameOver) {
                nodec += 1;
            } else {
                ctm = localCtm + 1;
                nodec += perftHelper(bd, kloc, depth - 1, ply+1);
            }

        }

        System.arraycopy(localBoard, 0, bd, 0, 256);
        System.arraycopy(localKloc, 0, kloc, 0, 2 );
        ctm = localCtm;

        return nodec;
    }

    public int getLaserMap(boolean otherPlayer, int mask)
    {
        int fctm = otherPlayer ? 1 ^ (ctm & 1) : (ctm & 1);   // move already make, thus xor needed
        //int fctm = (ctm & 1);   // move already make, thus xor needed
        int cur =  kloc[fctm];
        int bdir = bd[cur] & 3;
        int beam[] = {-16, 1, 16, -1};

        if ( (bd[cur] >> 2) == 2 ) {
            System.out.printf("cur = %x\n", cur );
            System.out.printf("king on wrong square: \n%s\n", getBoard());
            System.exit(1);
        }


        while (true) {
            int inc = beam[bdir];
            cur += inc;
            int c = bd[cur];
            laser_map[cur] |= mask;
            if (c == IBIT) return 0;  // ran off board edge

            if (c != 0) {
                int typ = (c >> 2) & 3;  // typ of piece we hit
                int ori = c & 3;         // orientation of piece that is hit

                switch(typ) {
                case 1 : // pawn
                    if ( pawnback[bdir][ori] == 1 ) return cur;   // hit the back of a pawn
                    bdir = change[bdir][ori];
                    break;

                case 2 : // king
                    return  cur;     // sorry, game over my friend!

                default :
                    System.out.printf("HEY - SHOULD NOT BE HAPPENING!\n");
                    break;
                }
            }
        }
    }

    public int shootLaser()
    {
        int fctm = 1 ^ (ctm & 1);   // move already make, thus xor needed
        int cur =  kloc[fctm];
        int bdir = bd[cur] & 3;
        int beam[] = {-16, 1, 16, -1};

        if ( (bd[cur] >> 2) == 2 ) {
            System.out.printf("cur = %x\n", cur );
             System.out.printf("king on wrong square: \n%s\n", getBoard());
            System.exit(1);
        }


        while (true) {
            int curr_fil = cur % AS;
            int curr_rnk = ((cur - curr_fil) / AS) - FIRST_RANK;
            System.out.println(curr_fil);
            System.out.println(curr_rnk);

            int inc = beam[bdir];
            cur += inc;

            curr_fil = cur % AS;
            curr_rnk = ((cur - curr_fil) / AS) - FIRST_RANK;
            System.out.println(curr_fil);
            System.out.println(curr_rnk);
            System.out.println("\n");

            int c = bd[cur];
            if (c == IBIT) return 0;  // ran off board edge

            if (c != 0) {
                int typ = (c >> 2) & 3;  // typ of piece we hit
                int ori = c & 3;         // orientation of piece that is hit

                switch(typ) {
                case 1 : // pawn
                    if ( pawnback[bdir][ori] == 1 ) return cur;   // hit the back of a pawn
                    bdir = change[bdir][ori];
                    break;

                case 2 : // king
                    System.out.println("We hit the king somehow...\n");
                    return  cur;     // sorry, game over my friend!

                default :
                    System.out.printf("HEY - SHOULD NOT BE HAPPENING!\n");
                    break;
                }
            }
        }
    }

    public void gen()
    {
        int dir[] = { 15, -1, -17, 16, -16, 17, 1, -15 };
        int diagonal_dir[] = {-17, -15, 15, 17};
        mvcount = 0;

        // Clear laser map
        for (int i = 0; i < AS*AS; i++) {
            laser_map[i] = 0;
        }

        getLaserMap(true, 1); // shoot enemy laser;
        boolean laserZapsPiece = getLaserMap(false, 2) != 0; // shoot friendly laser

        for (int f = 0; f < BS; f++) {
            for (int r = 0; r < BS; r++) {
                int sq = square_of(f, r);

                // Check if there is a piece to move.
                if (!containsPiece(sq))
                    continue;

                 // Check color of piece is same color as color to move.
                if (!isSameColor(sq, ctm))
                    continue;

                int typ = (bd[sq] >> 2) & 3;

                for (int d = 0; d < 8; d++) {
                    int dest = sq + dir[d];
                    if (bd[dest] == IBIT)
                        continue;    // illegal square

                    if(containsPiece(dest))
                        continue;   // Can't move into another piece

                    mvlist[mvcount++] = moveOf(typ, 0, sq, sq, dest);
                }
                // Rotations
                mvlist[mvcount++] = moveOf(typ, 1, sq, sq, sq);
                mvlist[mvcount++] = moveOf(typ, 2, sq, sq, sq);
                mvlist[mvcount++] = moveOf(typ, 3, sq, sq, sq);

                if(laserZapsPiece && typeOf(sq) == KING){
                    mvlist[mvcount++] = moveOf(typ, 0, sq, sq, sq);
                }
            }
        }
    }

    public String getBoard() {
        String board = "";
        String pd[] = { "nw", "ne", "se", "sw" };
        String kd[] = { "nn", "ee", "ss", "ww" };

        for(int r = 0; r < BS; r++) {
            board += "\n";
            for (int f = 0; f < BS; f++) {
                int sq = bd_index(r, f);
                if (bd[sq] == 0) { board += " --"; continue; }
                int dir = bd[sq] & 3;
                int x = (bd[sq] >> 2) & 3;
                int c = bd[sq] & IBIT;

                if (c == WBIT) {
                    if (x == 1)
                        board += ' ' + pd[dir].toUpperCase();
                    else
                        board += ' ' + kd[dir].toUpperCase();
                } else {
                    if (x == 1)
                        board += ' ' + pd[dir];
                    else
                        board += ' ' + kd[dir];
                }

            }
        }
        board += "\n";
        return board;
    }

    public void cleanup() { return; }
}
