import imageformats;
import std.stdio;
import std.conv;

int main(string[] args)
{
	if (args.length < 2)
	{
		stderr.writeln("Usage: " ~ args[0] ~ " [image] (image name)");
		return 1;
	}

	string name = "IMAGE";
	if (args.length >= 3)
		name = args[2];

	IFImage img = read_image(args[1], ColFmt.RGB);

	writeln("#define " ~ name ~ "_WIDTH " ~ img.w.to!string);
	writeln("#define " ~ name ~ "_HEIGHT " ~ img.h.to!string);
	write("static const uint16_t " ~ name ~ "[] = { ");

	for (int i = 0; i < img.pixels.length; i+=3)
	{
		ubyte b = (img.pixels[i] & 0b11111000) >> 3;
		ubyte g = (img.pixels[i + 1] & 0b11111100) >> 2;
		ubyte r = (img.pixels[i + 2] & 0b11111000) >> 3;

		ushort px = r | cast(ushort)(g << 5) | cast(ushort)(b << 11);

		write("0x" ~ px.to!string(16));
		if (i + 3 < img.pixels.length)
			write(", ");
	}

	writeln("};");
	return 0;
}
