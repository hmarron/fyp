public enum Command {
	RIGHT(1,"Right"), LEFT(2,"Left"), UP(3,"Up"), DOWN(4,"Down"), STOP(5,"Stop"), SEARCH(6,"Search");
 
 private int code;
 private String name;
 
 private Command(int c, String s) {
   code = c;
   name = s;
 }
 
 public int getCode() {
   return code;
 }
 
 public String toString() {
   return name;
 }
}
