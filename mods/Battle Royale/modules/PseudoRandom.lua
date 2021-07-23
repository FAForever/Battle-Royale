
PseudoRandom = { };
PseudoRandom.__index = PseudoRandom;

function PseudoRandom:Initiate(collection)

    -- do the linking
    local prnd = { };
    setmetatable(prnd, PseudoRandom);

    -- keep track of our current index and of the collection.
    prnd.index = table.getn(collection);
    prnd.collection = collection;

    return prnd;
end

function PseudoRandom:GetValue()

    -- check if we're still within the boundaries of the table.
    -- if not, we shuffle!
    local n = table.getn(self.collection);
    if self.index == n then
        self:Shuffle();
        self.index = 0;
    end

    -- return the next value we wish to return.
    self.index = self.index + 1;
    return self.collection[self.index];
end

function PseudoRandom:Shuffle()

    -- shuffles the collection. Tables are send by reference
    -- in Lua, see:
    -- https://stackoverflow.com/questions/6128152/function-variable-scope-pass-by-value-or-reference
    function Shuffle(collection)

        -- https://en.wikipedia.org/wiki/Fisher–Yates_shuffle
        -- To shuffle an array a of n elements (indices 0..n-1):
        -- for i from n−1 downto 1 do
            -- j ← random integer such that 0 ≤ j ≤ i
            -- exchange a[j] and a[i]

        local n = table.getn(collection)
        for k = n, 1, -1 do

            local j = math.floor(Random() * (k - 1) + 1);

            -- 'exchange' them
            local value = collection[j];
            collection[j] = collection[k];
            collection[k] = value;
        end

        return collection;
    end

    self.collection = Shuffle(self.collection);
end