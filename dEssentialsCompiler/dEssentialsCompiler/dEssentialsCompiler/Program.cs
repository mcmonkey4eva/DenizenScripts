using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace dEssentialsCompiler
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("mcmonkey's Denizen Script Compiler");
            string name = File.ReadAllText("compiler.txt").Replace("\r", "").Replace("\n", "");
            string[] files = Directory.GetFiles(Environment.CurrentDirectory, "*.yml");
            StringBuilder complete = new StringBuilder();
            for (int i = 0; i < files.Length; i++)
            {
                if (files[i].ToLower().EndsWith("core.yml"))
                {
                    complete.Append(File.ReadAllText(files[i]));
                }
            }
            for (int i = 0; i < files.Length; i++)
            {
                if (!files[i].ToLower().EndsWith("core.yml"))
                {
                    complete.Append(File.ReadAllText(files[i]));
                }
            }
            File.WriteAllText(Environment.CurrentDirectory + name, complete.ToString());
        }
    }
}
