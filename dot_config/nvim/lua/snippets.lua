local M = {}
M.rust = {}

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local cptemplate = s(
	"cptemplate",
	fmt(
		[[
#[allow(unused_imports)]
use std::{
    io::{BufRead, Write},
    str::FromStr,
};

fn main() {
    let mut reader = Reader::new();
    let mut stdout = std::io::BufWriter::new(std::io::stdout().lock());

    @$
}

struct Reader {
    lines: std::io::Lines<std::io::StdinLock<'static>>,
}

#[allow(dead_code)]
impl Reader {
    fn new() -> Self {
        Self {
            lines: std::io::stdin().lock().lines(),
        }
    }

    fn read_1<T1>(&mut self) -> T1
    where
        T1: FromStr,
        <T1 as FromStr>::Err: std::fmt::Debug,
    {
        let line = self.lines.next().unwrap().unwrap();
        let mut line = line.split_whitespace();
        line.next().unwrap().parse::<T1>().unwrap()
    }

    fn read_2<T1, T2>(&mut self) -> (T1, T2)
    where
        T1: FromStr,
        <T1 as FromStr>::Err: std::fmt::Debug,
        T2: FromStr,
        <T2 as FromStr>::Err: std::fmt::Debug,
    {
        let line = self.lines.next().unwrap().unwrap();
        let mut line = line.split_whitespace();
        let v1 = line.next().unwrap().parse::<T1>().unwrap();
        let v2 = line.next().unwrap().parse::<T2>().unwrap();
        (v1, v2)
    }

    fn read_3<T1, T2, T3>(&mut self) -> (T1, T2, T3)
    where
        T1: FromStr,
        <T1 as FromStr>::Err: std::fmt::Debug,
        T2: FromStr,
        <T2 as FromStr>::Err: std::fmt::Debug,
        T3: FromStr,
        <T3 as FromStr>::Err: std::fmt::Debug,
    {
        let line = self.lines.next().unwrap().unwrap();
        let mut line = line.split_whitespace();
        let v1 = line.next().unwrap().parse::<T1>().unwrap();
        let v2 = line.next().unwrap().parse::<T2>().unwrap();
        let v3 = line.next().unwrap().parse::<T3>().unwrap();
        (v1, v2, v3)
    }

    fn read_4<T1, T2, T3, T4>(&mut self) -> (T1, T2, T3, T4)
    where
        T1: FromStr,
        <T1 as FromStr>::Err: std::fmt::Debug,
        T2: FromStr,
        <T2 as FromStr>::Err: std::fmt::Debug,
        T3: FromStr,
        <T3 as FromStr>::Err: std::fmt::Debug,
        T4: FromStr,
        <T4 as FromStr>::Err: std::fmt::Debug,
    {
        let line = self.lines.next().unwrap().unwrap();
        let mut line = line.split_whitespace();
        let v1 = line.next().unwrap().parse::<T1>().unwrap();
        let v2 = line.next().unwrap().parse::<T2>().unwrap();
        let v3 = line.next().unwrap().parse::<T3>().unwrap();
        let v4 = line.next().unwrap().parse::<T4>().unwrap();
        (v1, v2, v3, v4)
    }

    fn read_vec<T>(&mut self) -> Vec<T>
    where
        T: FromStr,
        <T as FromStr>::Err: std::fmt::Debug,
    {
        self.lines
            .next()
            .unwrap()
            .unwrap()
            .split_whitespace()
            .map(|x| x.parse::<T>().unwrap())
            .collect()
    }

    fn read_string(&mut self) -> String {
        self.lines.next().unwrap().unwrap()
    }
}

]],
		{ i(1) },
		{ delimiters = "@$" }
	)
)
table.insert(M.rust, cptemplate)

return M
