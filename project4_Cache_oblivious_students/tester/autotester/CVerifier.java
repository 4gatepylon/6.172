
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

import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class CVerifier implements Verifier {
    private Pattach  p;

    public CVerifier(String referee) {
        p = new Pattach(referee);
        p.snd("uci\n");
        p.waitfor( "uciok" );
    }

    public String getBoard() {
        p.snd("display\n");
        return p.waitforFull("DoneDisplay");
    }

    public int makeToSan(String mv) {
        p.snd("move " + mv + "\n");
        int numVictims = Integer.parseInt(p.waitfor("move victims").split(" ")[2]);
        return numVictims;
    }

    public void setupPosition(String position) {
        if (position == null || position.isEmpty())
            p.snd("position startpos\n");
        else
            p.snd("position " + position + "\n");
        return;
    }

    public String status() {
        p.snd("status\n");
        return p.waitfor("status").substring(7);
    }

    public void cleanup() {
        p.snd("quit\n");
        p.cleanup();
    }
}
