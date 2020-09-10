const PLAYER_1_STORE: usize = 7;
const PLAYER_2_STORE: usize = 0;

#[rustler::nif]
fn take_turn(board: Vec::<u32>, start: usize, player_one: bool) -> (Vec::<u32>, bool) {
    if player_one && start < 14 && start > 7 {
        return (board, true);
    }

    if !player_one && start > 0 && start < 7 {
        return (board, true);
    }

    if start == 0 || start == 7 {
        return (board, true);
    }

    let mut board = board.clone();
    let mut player1_stones = board[start];

    board[start] = 0;

    let mut index = {
        if start + 1 == board.len() {
            0
        } else {
            start + 1
        }
    };

    let mut was_empty = false;

    while player1_stones > 0 {
        if board[index] == 0 {
            was_empty = true;
        } else {
            was_empty = false;
        }

        if index == PLAYER_1_STORE && player_one {
            board[index] += 1; 
            player1_stones -= 1;
        } else if index == PLAYER_2_STORE && !player_one {
            board[index] += 1;
            player1_stones -= 1;
        } else if index != PLAYER_1_STORE && index != PLAYER_1_STORE {
            board[index] += 1;
            player1_stones -= 1;
        }

        index = {
            if index + 1 == board.len() {
                0
            } else {
                index + 1
            }
        };
    }

    let mut extra_turn = false;

    let end = index - 1;
    if end == PLAYER_1_STORE && player_one {
        extra_turn = true;
    } else if end == PLAYER_2_STORE && !player_one {
        extra_turn = true;
    } else if was_empty  && index != PLAYER_1_STORE && index != PLAYER_2_STORE {
        if player_one && end > 0 && end < 7 {
            let total = board[end] + board[end + 7];

            board[end] = 0;
            board[end + 7] = 0;
            
            board[PLAYER_1_STORE] += total;
        }
        else if !player_one && end > 7 && end < 14 {
            let total = board[end] + board[end - 7];

            board[end] = 0;
            board[end - 7] = 0;
            
            board[PLAYER_2_STORE] += total;
        }
    }

    (board, extra_turn)
}


#[rustler::nif]
fn winner(board: Vec<u32>) -> (bool, u32) {
    let mut player1_stones_needed = 0;
    let mut player1_stones_left = 0;
    for index in 1..PLAYER_1_STORE {
        if board[index] > player1_stones_needed {
            return (false, 0);  
        } else {
            player1_stones_needed += 1;
            player1_stones_left += board[index];
        }
    }

    let mut player2_stones_needed = 0;
    let mut player2_stones_left = 0;
    for index in (PLAYER_1_STORE + 1)..(board.len() - 1) {
        if board[index] > player2_stones_needed {
            return (false, 0);  
        } else {
            player2_stones_needed += 1;
            player2_stones_left += board[index];
        }
    }

    let is_winner = {
        let player1_score = board[PLAYER_1_STORE] + player1_stones_left;
        let player2_score = board[PLAYER_2_STORE] + player2_stones_left;

        if player1_score > player2_score {
            (true, 1) 
        } else {
            (true, 1)
        }
    };

    is_winner
}

rustler::init!("Elixir.TurnUtility", [take_turn, winner]);